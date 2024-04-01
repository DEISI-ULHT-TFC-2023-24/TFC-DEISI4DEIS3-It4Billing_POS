import 'package:flutter/material.dart';

import '../../main.dart';
import '../../objetos/metodoPagamentoObj.dart';
import '../../objetos/pedidoObj.dart';
import '../Cliente/addClientePage.dart';
import 'concluirCobrancaDividida.dart';

class CobrarDivididoPage extends StatefulWidget {
  late PedidoObj pedido;
  double valorCobrar;


  CobrarDivididoPage({
    Key? key,
    required this.valorCobrar,
    required this.pedido,
  }) : super(key: key);

  @override
  _CobrarDivididoPage createState() => _CobrarDivididoPage();
}

class _CobrarDivididoPage extends State<CobrarDivididoPage> {
  List<MetodoPagamentoObj> metodos = database.getAllMetodosPagamento();
  final FocusNode _focusNode = FocusNode();

  // Controladores dos campos de texto
  TextEditingController _dinheiroRecebidoController = TextEditingController();
  TextEditingController _trocoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dinheiroRecebidoController.text =
        widget.valorCobrar.toStringAsFixed(2);
    _trocoController.text =
        (double.parse(_dinheiroRecebidoController.text) - double.parse(widget.valorCobrar.toStringAsFixed(2))).toStringAsFixed(2);
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
            (double.parse(_dinheiroRecebidoController.text) - widget.valorCobrar).toStringAsFixed(2);

      });
    }
  }

  bool _toggleVisibility(){
    bool isVisible = false;
    if ((double.parse(_dinheiroRecebidoController.text) - double.parse(widget.valorCobrar.toStringAsFixed(2))) >= 0){
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back), // Ícone padrão de voltar
            onPressed: () {
              // Navegar para a página anterior
              Navigator.pop(context, false);
            },
          ),
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
                        '${widget.valorCobrar.toStringAsFixed(2)} €',
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
                        hintText: widget.valorCobrar.toStringAsFixed(2),
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
                                  // Entrar no final da compra

                                  double dinheiroRecebido = double.parse(_dinheiroRecebidoController.text);
                                  double troco = double.parse(_trocoController.text);
                                  metodos[index].valor += dinheiroRecebido - troco;
                                  database.addMetodoPagamento(metodos[index]);

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ConcluirCobrancaDivididaPage(
                                            pedido: widget.pedido,
                                            troco: _trocoController.text,
                                            valorCobrar: widget.valorCobrar,
                                          )
                                      ));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(color: Colors.black),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    metodos[index].nome,
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
