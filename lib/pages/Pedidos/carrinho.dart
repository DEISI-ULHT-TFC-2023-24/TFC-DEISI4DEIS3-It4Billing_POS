import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:it4billing_pos/main.dart';
import 'package:it4billing_pos/pages/Cliente/addClientePage.dart';
import 'package:it4billing_pos/pages/Pedidos/editCarrinho.dart';
import 'package:it4billing_pos/pages/Pedidos/escolhaLocal.dart';
import 'package:it4billing_pos/pages/Pedidos/pedidos.dart';

import '../../objetos/artigoObj.dart';
import '../../objetos/categoriaObj.dart';
import '../../objetos/pedidoObj.dart';
import 'cobrar.dart';

class CarrinhoPage extends StatefulWidget {
  late List<PedidoObj> pedidos = [];
  late List<Categoria> categorias = [];
  late List<Artigo> artigos = [];
  late PedidoObj pedido;

  CarrinhoPage({
    Key? key,
    required this.pedidos,
    required this.categorias,
    required this.artigos,
    required this.pedido,
  }) : super(key: key);

  @override
  _CarrinhoPageState createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage> {
  late Map<int, int> artigosAgrupados;

  Map<int, int> groupItems(List<int> listaIds) {
    Map<int, int> frequenciaIds = {};

    for (int id in listaIds) {
      if (frequenciaIds.containsKey(id)) {
        frequenciaIds[id] = (frequenciaIds[id] ?? 0) + 1;
      } else {
        frequenciaIds[id] = 1;
      }
    }

    return frequenciaIds;
  }

  @override
  void initState() {
    super.initState();
    artigosAgrupados = groupItems(widget.pedido.artigosPedidoIds);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.pedido.nome),
          backgroundColor: const Color(0xff00afe9),
          actions: [
            IconButton(
              icon: const Icon(Icons.person_add_outlined),
              tooltip: 'Open shopping cart',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AdicionarClientePage(
                        pedido: widget.pedido,
                        pedidos: widget.pedidos,
                        categorias: widget.categorias,
                        artigos: widget.artigos)));
              },
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                // Lógica para lidar com as opções selecionadas
                print('Opção selecionada: ${widget.pedido.nome}');
                if (value == 'Eliminar pedido') {
                  database.removePedido(widget.pedido.id);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => PedidosPage()));
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'Mover artigo',
                  child: ListTile(
                    leading: Icon(Icons.move_up),
                    title: Text('Mover artigo'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'Eliminar pedido',
                  child: ListTile(
                    leading: Icon(Icons.delete_outline),
                    title: Text('Eliminar pedido'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'Sincronizar',
                  child: ListTile(
                    leading: Icon(Icons.sync),
                    title: Text('Sincronizar'),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: artigosAgrupados.length,
                itemBuilder: (context, index) {
                  int artigoId = artigosAgrupados.keys.elementAt(index);
                  int quantidade = artigosAgrupados[artigoId]!;
                  double valor = database.getArtigo(artigoId)!.price;
                  Artigo artigo = database.getArtigo(artigoId)!;

                  /// isto vai dar problemas no editar carrinho
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        //entrar no artigo e quantidades e tal
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditCarrinho(
                                      artigo: artigo,
                                      quantidade: quantidade,
                                      pedido: widget.pedido,
                                      artigos: widget.artigos,
                                      categorias: widget.categorias,
                                      pedidos: widget.pedidos,
                                    )));
                      },
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(
                            const BorderSide(color: Colors.white12)),
                        // Linha de borda preta
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        // Fundo white
                        fixedSize:
                            MaterialStateProperty.all(const Size(50, 60)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                  artigo.nome.length > 10
                                      ? artigo.nome.substring(0, 20)
                                      : artigo.nome,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16)),
                              const SizedBox(width: 10),
                              Text('x $quantidade',
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16)),
                            ],
                          ),
                          Text('${(valor * quantidade).toStringAsFixed(2)} €',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 45, right: 45),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(
                      '${widget.pedido.calcularValorTotal().toStringAsFixed(2)} €',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, bottom: 30),
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (widget.pedido.artigosPedidoIds.isNotEmpty) {
                            if (widget.pedido.localId == -1) {
                              print(
                                  'Lista de locais: ${database.getAllLocal().length}');
                              database.getAllLocal().forEach((element) {
                                print(element.nome);
                              });

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LocalPage(
                                            pedidos: widget.pedidos,
                                            pedido: widget.pedido,
                                          )));
                            } else {
                              await database.addPedido(widget.pedido);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PedidosPage()));
                            }
                          } else {
                            Fluttertoast.showToast(
                              msg: "Adicionar artigos primeiro",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.grey,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Colors.black),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'GRAVAR',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20), // Espaço entre os botões
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0, bottom: 30),
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (widget.pedido.artigosPedidoIds.isNotEmpty) {
                            // fazer a navegação para a proxima pag a de cobrança.

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Cobrar(
                                          pedidos: widget.pedidos,
                                          pedido: widget.pedido,
                                          categorias: widget.categorias,
                                          artigos: widget.artigos,
                                        )));
                          } else {
                            Fluttertoast.showToast(
                              msg: "Adicionar artigos primeiro",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.grey,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff00afe9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Colors.black),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            'COBRAR',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
