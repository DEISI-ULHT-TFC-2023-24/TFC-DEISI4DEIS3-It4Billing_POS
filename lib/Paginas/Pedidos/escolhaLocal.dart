import 'package:flutter/material.dart';
import 'package:it4billing_pos/main.dart';
import 'package:it4billing_pos/objetos/localObj.dart';
import 'package:it4billing_pos/Paginas/Pedidos/pedidos.dart';

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

                        await database.addPedido(pedido);

                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PedidosPage()));// Fechar a página
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


