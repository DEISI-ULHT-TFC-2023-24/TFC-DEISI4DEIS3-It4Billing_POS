import 'package:flutter/material.dart';
import 'package:it4billing_pos/main.dart';
import 'package:it4billing_pos/objetos/VendaObj.dart';
import 'package:it4billing_pos/pages/Pedidos/pedidos.dart';

import '../../objetos/pedidoObj.dart';

class ConcluirPedido extends StatefulWidget {
  late PedidoObj pedido;
  late String troco;

  ConcluirPedido({
    Key? key,
    required this.pedido,
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

  void concluirVenda() {
    // Lógica para concluir a venda
    VendaObj venda = VendaObj(
        nome: widget.pedido.nome,
        hora: widget.pedido.hora,
        funcionarioID: widget.pedido.funcionarioID,
        localId: widget.pedido.localId,
        total: widget.pedido.total);
    venda.artigosPedidoIds = widget.pedido.artigosPedidoIds;
    venda.nrArtigos = widget.pedido.nrArtigos;

    database.addVenda(venda);
    if(widget.pedido.id != 0) {
      if (database.getPedido(widget.pedido.id) != null){
        database.removePedido(widget.pedido.id);
      }
    }
    if (widget.pedido.funcionarioID != 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PedidosPage(),
        ),
      );
      print('Venda concluída!');
    }

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
            onPressed: concluirVenda,
            // acrescentar a lógica de pagamento, impressora, enviar e-mail, etc.

            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff00afe9),
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
