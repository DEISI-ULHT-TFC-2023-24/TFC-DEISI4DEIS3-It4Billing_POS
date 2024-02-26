import 'package:flutter/material.dart';
import 'package:it4billing_pos/objetos/localObj.dart';
import 'package:it4billing_pos/pages/Pedidos/concluirPedido.dart';
import 'package:it4billing_pos/pages/Pedidos/pedidos.dart';

import '../../objetos/artigoObj.dart';
import '../../objetos/categoriaObj.dart';
import '../../objetos/pedidoObj.dart';

class Cobrar extends StatefulWidget {
  late List<PedidoObj> pedidos = [];
  late List<Categoria> categorias = [];
  late List<Artigo> artigos = [];
  late PedidoObj pedido;

  Cobrar({
    Key? key,
    required this.pedidos,
    required this.categorias,
    required this.artigos,
    required this.pedido,
  }) : super(key: key);

  @override
  _Cobrar createState() => _Cobrar();
}

class _Cobrar extends State<Cobrar> {
  List<String> metodos = Pedidos().getMetodosPagamento();
  final FocusNode _focusNode = FocusNode();

  // Controladores dos campos de texto
  TextEditingController _dinheiroRecebidoController = TextEditingController();
  TextEditingController _trocoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dinheiroRecebidoController.text =
        widget.pedido.calcularValorTotal().toStringAsFixed(2);
    _trocoController.text =
        (double.parse(_dinheiroRecebidoController.text) - double.parse(widget.pedido.calcularValorTotal().toStringAsFixed(2))).toStringAsFixed(2);
    _focusNode.addListener(_onFocusChanged);

  }

  @override
  void dispose() {
    _dinheiroRecebidoController.dispose();
    _trocoController.dispose();
    _focusNode.removeListener(_onFocusChanged);
    super.dispose();
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus) {
      setState(() {
        _trocoController.text =
            (double.parse(_dinheiroRecebidoController.text) - widget.pedido.calcularValorTotal()).toStringAsFixed(2);

      });
    }
  }

  bool _toggleVisibility(){
    bool isVisible = false;
    if ((double.parse(_dinheiroRecebidoController.text) - double.parse(widget.pedido.calcularValorTotal().toStringAsFixed(2))) >= 0){
      isVisible = true;
    }
    return isVisible;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 40, right: 40, bottom: 10.0),
                    child: TextField(
                      focusNode: _focusNode,
                      controller: _dinheiroRecebidoController,
                      decoration: InputDecoration(
                        labelText: 'Dinheiro Recebido',
                        labelStyle: const TextStyle(color: Color(0xff00afe9),fontSize: 14),
                        hintText: widget.pedido.calcularValorTotal().toStringAsFixed(2),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 40, right: 40, bottom: 10.0),
                    child: IgnorePointer(
                      child: TextField(
                        controller: _trocoController,
                        decoration: const InputDecoration(
                          labelText: 'Troco',
                          labelStyle: TextStyle(color: Color(0xff00afe9),fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              _toggleVisibility() ? SizedBox(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            // fazer a navegação para a DIVIDIR CONTA.
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: Colors.black),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              'DIVIDIR CONTA',
                              style: TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ), //DIVIDIR CONTA
                    const SizedBox(height: 30),
                    const Center(
                      child: Text('Selecione um método de pagamento:',
                          style: TextStyle(color: Colors.grey, fontSize: 18)),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: metodos.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 40, right: 40, bottom: 10.0),
                            child: SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Entrar no final da compra ..... outra vez clh grava aamerdas ....+

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ConcluirPedido(
                                            pedidos: widget.pedidos,
                                            pedido: widget.pedido,
                                            categorias: widget.categorias,
                                            artigos: widget.artigos,
                                            troco: _trocoController.text,
                                          )));
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(color: Colors.black),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    metodos[index],
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ), //METODOS DE PAGAMENTO
                    const SizedBox(height: 30)
                  ],
                ),

              ) : const Center(
                child: Text('Dinheiro insuficiente!',style: TextStyle(fontSize: 20),),
              )
            ],
          ),
        ),
      ),

    );
  }
}
