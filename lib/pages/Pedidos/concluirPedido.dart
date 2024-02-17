import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:it4billing_pos/objetos/localObj.dart';
import 'package:it4billing_pos/pages/Pedidos/editCarrinho.dart';
import 'package:it4billing_pos/pages/Pedidos/escolhaLocal.dart';
import 'package:it4billing_pos/pages/Pedidos/pedidos.dart';

import '../../objetos/artigoObj.dart';
import '../../objetos/categoriaObj.dart';
import '../../objetos/pedidoObj.dart';

class ConcluirPedido extends StatefulWidget {
  late List<PedidoObj> pedidos = [];
  late List<Categoria> categorias = [];
  late List<Artigo> artigos = [];
  late PedidoObj pedido;
  late List<LocalObj> locais = [];
  late String troco;

  ConcluirPedido({
    Key? key,
    required this.pedidos,
    required this.categorias,
    required this.artigos,
    required this.pedido,
    required this.locais,
    required this.troco,
  }) : super(key: key);

  @override
  _ConcluirPedido createState() => _ConcluirPedido();
}

class _ConcluirPedido extends State<ConcluirPedido> {


  @override
  void initState() {
    super.initState();

  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.pedido.nome),
          backgroundColor: const Color(0xff00afe9),
          actions: [
            IconButton(
              icon: const Icon(Icons.person_add_outlined),
              tooltip: 'Open client',
              onPressed: () {
                // handle the press
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 45, right: 45),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total pago',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 10),
                      Text(
                          '${widget.pedido.calcularValorTotal().toStringAsFixed(2)} €',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 30),
                      const Text('Troco',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 10),
                      Text('${widget.troco} €',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 30, left: 80, right: 80),
        child: SizedBox(
          width: double.infinity, // Largura total da tela
          child: ElevatedButton(
            onPressed: () {
              // acrescentar a lógica de pagamento, impressora, enviar e-mail, etc.
              widget.pedidos.remove(widget.pedido);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Pedidos(
                    pedidos: widget.pedidos,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: const Color(0xff00afe9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Colors.black),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: Text(
                'CONCLUIR VENDA',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ),
      ),

    );

  }



}
