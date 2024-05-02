import 'package:flutter/material.dart';
import 'package:it4billing_pos/main.dart';
import 'package:it4billing_pos/objetos/localObj.dart';
import 'package:it4billing_pos/Paginas/Pedidos/pedidos.dart';

import '../../database/objectbox.g.dart';
import '../../objetos/artigoObj.dart';
import '../../objetos/pedidoObj.dart';

class LocalPage extends StatelessWidget {
  List<PedidoObj> pedidos = [];
  List<LocalObj> locais = database.getAllLocal();
  PedidoObj pedido;

  LocalPage({
    Key? key,
    required this.pedidos,
    required this.pedido,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salvar pedido', style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close,color: Colors.black), // Ícone de fechar (x)
          onPressed: () {
            Navigator.of(context).pop(); // Fechar a página
          },
        ),
      ),
      body: Center(
        child:
            ListView.builder(
              itemCount: locais.length,
              itemBuilder: (context, index) {
                final local = locais[index];
                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        // Lógica para lidar com a seleção do local
                        pedido.localId = local.id;
                        if(local.ocupado){
                          database.getAllPedidos().forEach((pedidoExistente) {
                            if(pedidoExistente.localId == local.id){
                              /// tenho de fazer alguma coisa para juntar ao outro pedido
                              pedidoExistente.artigosPedidoIds = pedidoExistente.artigosPedidoIds + pedido.artigosPedidoIds;
                              Set<Artigo> conjuntoArtigos = {...pedidoExistente.artigosPedido, ...pedido.artigosPedido};
                              pedidoExistente.artigosPedido.clear(); // Limpa os artigos existentes, se necessário
                              for (var artigo in conjuntoArtigos) {
                                pedidoExistente.artigosPedido.add(artigo); // Adiciona cada artigo ao pedido existente
                              }

                          database.addPedido(pedidoExistente);
                            }
                          });
                        } else {
                          local.ocupado = true;
                          await database.addLocal(local);
                          await database.addPedido(pedido);
                        }
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PedidosPage()));// Fechar a página
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        elevation: MaterialStateProperty.all<double>(0), // Remove a sombra
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero), // Remove o padding padrão
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Reduz o tamanho do botão
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0,bottom: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 40.0),
                            child: Text(local.nome, style: const TextStyle(color: Colors.black)),
                          ),
                        ),
                      ),
                    ),
                    const Divider(height: 0, thickness: 1), // Linha separadora
                  ],
                );
              },
            ),

      ),
    );
  }
}


