import 'package:flutter/material.dart';

import '../../main.dart';
import '../../objetos/meusargumentos.dart';
import '../../objetos/pedidoObj.dart';
import '../../objetos/setupObj.dart';
import '../Cliente/addClientePage.dart';

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
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_outlined),
            tooltip: 'Open client',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AdicionarClientePage(
                      pedido: widget.pedido,
                      pedidos: database.getAllPedidos(),
                      artigos: database.getAllArtigos())
              ));
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
                        '${widget.valorCobrar} €',
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
                    if (widget.pedido.clienteID != 0 && widget.pedido.clienteID != database.getAllClientes()[0].id)
                      Row(
                        children: [
                          Checkbox(
                            value: widget.setup.email,
                            onChanged: (value) {
                              setState(() {
                                widget.setup.email = value!;
                                _showEmailField = value;
                              });
                            },
                          ),
                          const Text('Enviar por email'),
                        ],
                      ),
                    if (_showEmailField)
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'Digite seu email',
                        ),
                      ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Checkbox(
                          value: widget.setup.imprimir,
                          onChanged: (value) {
                            setState(() {
                              widget.setup.imprimir = value!;
                            });
                          },
                        ),
                        const Text('Imprimir documento'),
                      ],
                    ),

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
