import 'package:flutter/material.dart';

import '../../main.dart';
import '../../objetos/meusArgumentos.dart';
import '../../objetos/pedidoObj.dart';
import '../../objetos/setupObj.dart';

class ConcluirCobrancaDivididaPage extends StatefulWidget {
  late PedidoObj pedido;
  late String troco;
  late int idMetudoUsado;
  double valorCobrar;
  SetupObj setup = database.getAllSetup()[0];

  ConcluirCobrancaDivididaPage({
    Key? key,
    required this.pedido,
    required this.troco,
    required this.valorCobrar,
    required this.idMetudoUsado,
  }) : super(key: key);

  @override
  _ConcluirCobrancaDivididaPage createState() =>
      _ConcluirCobrancaDivididaPage();
}

class _ConcluirCobrancaDivididaPage
    extends State<ConcluirCobrancaDivididaPage> {
  TextEditingController _emailController = TextEditingController();
  bool _showEmailField = false;

  @override
  void initState() {
    if (widget.pedido.clienteID != database.getAllClientes()[0].id) {
      if (database.getCliente(widget.pedido.clienteID)?.email != 'N/D') {
        _emailController = TextEditingController(
            text: database.getCliente(widget.pedido.clienteID)?.email);
      } else {
        _emailController = TextEditingController();
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pedido.nome),
        backgroundColor: const Color(0xff00afe9),
        actions: const [],
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
                        '${(widget.valorCobrar).toStringAsFixed(2)} €',
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
                        )
                    ),
                    const SizedBox(height: 20),
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
              Navigator.pop(context);
              Navigator.pop(context, MeusArgumentos(true, widget.idMetudoUsado));
            },
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
                'CONCLUIR PAGAMENTO',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
