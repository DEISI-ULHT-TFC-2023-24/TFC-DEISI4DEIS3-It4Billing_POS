import 'package:flutter/material.dart';
import 'package:it4billing_pos/pages/Pedidos/pedidos.dart';

import '../../objetos/artigoObj.dart';
import '../../objetos/categoriaObj.dart';
import '../../objetos/utilizadorObj.dart';
import '../../objetos/vendaObj.dart';

class Carrinho extends StatefulWidget {
  List<VendaObj> vendas = [];
  List<Categoria> categorias = [];
  List<Artigo> artigos = [];
  VendaObj venda;

  Carrinho({
    Key? key,
    required this.vendas,
    required this.categorias,
    required this.artigos,
    required this.venda,
  }) : super(key: key);

  @override
  _Carrinho createState() => _Carrinho();
}

class _Carrinho extends State<Carrinho> {
  late Map<Artigo, int> groupedItems;

  Map<Artigo, int> groupItems(List<Artigo> items) {
    Map<Artigo, int> artigosAgrupados = {};
    for (var item in items) {
      artigosAgrupados[item] = (artigosAgrupados[item] ?? 0) + 1;
    }
    return artigosAgrupados;
  }

  @override
  void initState() {
    super.initState();
    groupedItems = groupItems(widget.venda.artigosPedido);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Pedido 01'),
          backgroundColor: const Color(0xff00afe9),
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: groupedItems.length,
                itemBuilder: (context, index) {
                  Artigo item = groupedItems.keys.elementAt(index);
                  int quantity = groupedItems[item]!;
                  return Padding(
                    padding: const EdgeInsets.only( left: 20, right: 20, bottom: 10.0),
                    child:
                    ElevatedButton(
                      onPressed: () {
                        //entrar no artigo e quantidades e tal
                      },
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(
                            const BorderSide(color: Colors.white12)),
                        // Linha de borda preta
                        backgroundColor:
                        MaterialStateProperty.all(Colors.white),
                        // Fundo white
                        fixedSize: MaterialStateProperty.all(
                            const Size(50, 60)),
                      ),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.nome,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16)
                          ),
                          Text(
                              'x $quantity',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16)
                          ),
                          Text('€ ${((item.unitPrice*(item.taxPrecentage/100+1))* quantity).toStringAsFixed(2)}',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16)
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, bottom: 30),
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Adicione sua lógica para o primeiro botão aqui
                          widget.vendas.add(VendaObj(nome: "Pedido 01", hora: DateTime.now(), funcionario: Utilizador('Utilizador001', 1234 ),local: 'mesa: 0069'));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Pedidos(vendas: widget.vendas)
                              )
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey,
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
                const SizedBox(width: 30), // Espaço entre os botões
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0, bottom: 30),
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Adicione sua lógica para o segundo botão aqui
                        },
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xff00afe9),
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
