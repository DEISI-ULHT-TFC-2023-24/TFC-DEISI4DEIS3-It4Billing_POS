import 'package:flutter/material.dart';
import 'package:it4billing_pos/main.dart';
import 'package:it4billing_pos/objetos/VendaObj.dart';
import 'package:it4billing_pos/Paginas/Pedidos/pedidos.dart';

import '../../objetos/pedidoObj.dart';
import '../../objetos/setupObj.dart';
import '../Cliente/addClientePage.dart';

class ConcluirPedido extends StatefulWidget {
  late PedidoObj pedido;
  late String troco;
  SetupObj setup = database.getAllSetup()[0];

  ConcluirPedido({
    Key? key,
    required this.pedido,
    required this.troco,
  }) : super(key: key);

  @override
  _ConcluirPedidoState createState() => _ConcluirPedidoState();
}

class _ConcluirPedidoState extends State<ConcluirPedido> {
  late TextEditingController _emailController;
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
    if (widget.pedido.clienteID != 0 &&
        widget.pedido.clienteID != database.getAllClientes()[0].id) {
      _emailController.dispose();
    }
    super.dispose();
  }

  void concluirVenda() {
    VendaObj venda = VendaObj(
      nome: widget.pedido.nome,
      hora: widget.pedido.hora,
      funcionarioID: widget.pedido.funcionarioID,
      localId: widget.pedido.localId,
      total: widget.pedido.total,
    );
    venda.artigosPedidoIds = widget.pedido.artigosPedidoIds;
    venda.nrArtigos = widget.pedido.nrArtigos;

    database.addVenda(venda);
    if (widget.pedido.id != 0) {
      if (database.getPedido(widget.pedido.id) != null) {
        database.removePedido(widget.pedido.id);
      }
    }
    //if (widget.pedido.funcionarioID != 0) {   porque que isto esta aqui??
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => PedidosPage(),
      ),
          (route) => false, // Remove todas as rotas anteriores
    );
    print('Venda concluída!');
    //}
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Impede que o usuário volte usando o botão de voltar do dispositivo
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.pedido.nome),
          backgroundColor: const Color(0xff00afe9),
          automaticallyImplyLeading: false, // Remove o ícone de voltar
          actions: [
            IconButton(
              icon: const Icon(Icons.person_add_outlined),
              tooltip: 'Open client',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AdicionarClientePage(
                        pedido: widget.pedido,
                        pedidos: database.getAllPedidos(),
                        artigos: database.getAllArtigos())));
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
                      const Text(
                        'Total pago',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${widget.pedido.calcularValorTotal().toStringAsFixed(2)} €',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Troco',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${widget.troco} €',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      //verifica se tem algum clente ou se é o cliente predefenido
                      if (widget.pedido.clienteID != 0 &&
                          widget.pedido.clienteID !=
                              database.getAllClientes()[0].id)
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
            width: double.infinity,
            child: ElevatedButton(
              onPressed: concluirVenda,
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
      ),
    );
  }
}
