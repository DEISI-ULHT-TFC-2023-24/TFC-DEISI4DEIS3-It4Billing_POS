import 'package:flutter/material.dart';
import 'package:it4billing_pos/Paginas/Pedidos/concluirPedido.dart';
import 'package:it4billing_pos/Paginas/Pedidos/dividirConta.dart';

import '../../main.dart';
import '../../objetos/artigoObj.dart';
import '../../objetos/metodoPagamentoObj.dart';
import '../../objetos/pedidoObj.dart';
import '../../objetos/turnoObj.dart';
import '../Cliente/addClientePage.dart';
import 'editCarrinho.dart';

class Cobrar extends StatefulWidget {
  late List<PedidoObj> pedidos = [];
  late List<Artigo> artigos = [];
  late PedidoObj pedido;
  late TurnoObj turno = database.getAllTurno()[0];

  Cobrar({
    Key? key,
    required this.pedidos,
    required this.artigos,
    required this.pedido,
  }) : super(key: key);

  @override
  _Cobrar createState() => _Cobrar();
}

class _Cobrar extends State<Cobrar> {
  List<MetodoPagamentoObj> metodos = database.getAllMetodosPagamento();
  final FocusNode _focusNode = FocusNode();

  // Controladores dos campos de texto
  TextEditingController _dinheiroRecebidoController = TextEditingController();
  TextEditingController _trocoController = TextEditingController();
  bool isTablet = false;
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    checkDeviceType();
  }

  void checkDeviceType() {
    // Getting the screen size
    final screenSize = MediaQuery.of(context).size;
    // Arbitrarily defining screen size greater than 600 width and height as tablet
    setState(() {
      isTablet = screenSize.width > 600 && screenSize.height > 600;
    });
  }

  @override
  void initState() {
    super.initState();
    _dinheiroRecebidoController.text =
        widget.pedido.calcularValorTotal().toStringAsFixed(2);
    _trocoController.text = (double.parse(_dinheiroRecebidoController.text) -
            double.parse(widget.pedido.calcularValorTotal().toStringAsFixed(2)))
        .toStringAsFixed(2);
    _focusNode.addListener(_onFocusChanged);
    artigosAgrupados = groupItems(widget.pedido.artigosPedidoIds);
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
            (double.parse(_dinheiroRecebidoController.text) -
                    widget.pedido.calcularValorTotal())
                .toStringAsFixed(2);
      });
    }
  }

  bool _toggleVisibility() {
    bool isVisible = false;
    if ((double.parse(_dinheiroRecebidoController.text) -
            double.parse(
                widget.pedido.calcularValorTotal().toStringAsFixed(2))) >=
        0) {
      isVisible = true;
    }
    return isVisible;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AdicionarClientePage(
                        pedido: widget.pedido,
                        pedidos: widget.pedidos,
                        artigos: widget.artigos)));
              },
            ),
          ],
        ),
        body: isTablet
            ? Row(
                children: [
                  // Lista de definições
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                            itemCount: artigosAgrupados.length,
                            itemBuilder: (context, index) {
                              int artigoId = artigosAgrupados.keys.elementAt(index);
                              int quantidade = artigosAgrupados[artigoId]!;
                              double? valor;
                              Artigo? artigo;

                              // Verifica se o artigo está presente na lista
                              for (Artigo artigoLista in widget.pedido.artigosPedido) {
                                if (artigoLista.nome == database.getArtigo(artigoId)!.nome) {
                                  print('preço do artigo na lista do pedido ${artigoLista.price}');
                                  artigo = artigoLista;
                                  break;
                                }
                              }
                              valor = artigo?.price;

                              /// isto vai dar problemas no editar carrinho??
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
                                              artigo: artigo!,
                                              quantidade: quantidade,
                                              pedido: widget.pedido,
                                              artigos: widget.artigos,
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
                                              artigo!.nome.length > 10
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
                                      Text('${(valor! * quantidade).toStringAsFixed(2)} €',
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
                      ],
                    ),
                  ), // Conteúdo da definição selecionada
                  Expanded(
                    flex: 4,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
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
                                    labelStyle: const TextStyle(
                                        color: Color(0xff00afe9), fontSize: 14),
                                    hintText: widget.pedido
                                        .calcularValorTotal()
                                        .toStringAsFixed(2),
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
                                      labelStyle: TextStyle(
                                          color: Color(0xff00afe9), fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          _toggleVisibility()
                              ? SizedBox(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // fazer a navegação para a DIVIDIR CONTA.

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DividirConta(
                                                      pedido: widget.pedido,
                                                      pedidos: widget.pedidos,
                                                    )));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(12),
                                          side: const BorderSide(
                                              color: Colors.black),
                                        ),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Text(
                                          'DIVIDIR CONTA',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ),
                                ), //DIVIDIR CONTA
                                const SizedBox(height: 30),
                                const Center(
                                  child: Text(
                                      'Selecione um método de pagamento:',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 18)),
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

                                              double dinheiroRecebido =
                                              double.parse(
                                                  _dinheiroRecebidoController
                                                      .text);
                                              double troco = double.parse(
                                                  _trocoController.text);
                                              metodos[index].valor +=
                                                  dinheiroRecebido - troco;
                                              if (metodos[index]
                                                  .nome
                                                  .toLowerCase() ==
                                                  'dinheiro') {
                                                widget.turno
                                                    .pagamentosDinheiro =
                                                    metodos[index].valor;
                                                database.addTurno(widget.turno);
                                              }
                                              database.addMetodoPagamento(
                                                  metodos[index]);

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ConcluirPedido(
                                                            pedido:
                                                            widget.pedido,
                                                            troco:
                                                            _trocoController
                                                                .text,
                                                          )));
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(12),
                                                side: const BorderSide(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                metodos[index].nome,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
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
                          )
                              : const Center(
                            child: Text(
                              'Dinheiro insuficiente!',
                              style: TextStyle(fontSize: 20),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : SingleChildScrollView(
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
                              labelStyle: const TextStyle(
                                  color: Color(0xff00afe9), fontSize: 14),
                              hintText: widget.pedido
                                  .calcularValorTotal()
                                  .toStringAsFixed(2),
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
                                labelStyle: TextStyle(
                                    color: Color(0xff00afe9), fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    _toggleVisibility()
                        ? SizedBox(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // fazer a navegação para a DIVIDIR CONTA.

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DividirConta(
                                                      pedido: widget.pedido,
                                                      pedidos: widget.pedidos,
                                                    )));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          side: const BorderSide(
                                              color: Colors.black),
                                        ),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Text(
                                          'DIVIDIR CONTA',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ),
                                ), //DIVIDIR CONTA
                                const SizedBox(height: 30),
                                const Center(
                                  child: Text(
                                      'Selecione um método de pagamento:',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 18)),
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

                                              double dinheiroRecebido =
                                                  double.parse(
                                                      _dinheiroRecebidoController
                                                          .text);
                                              double troco = double.parse(
                                                  _trocoController.text);
                                              metodos[index].valor +=
                                                  dinheiroRecebido - troco;
                                              if (metodos[index]
                                                      .nome
                                                      .toLowerCase() ==
                                                  'dinheiro') {
                                                widget.turno
                                                        .pagamentosDinheiro =
                                                    metodos[index].valor;
                                                database.addTurno(widget.turno);
                                              }
                                              database.addMetodoPagamento(
                                                  metodos[index]);

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ConcluirPedido(
                                                            pedido:
                                                                widget.pedido,
                                                            troco:
                                                                _trocoController
                                                                    .text,
                                                          )));
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                side: const BorderSide(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                metodos[index].nome,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
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
                          )
                        : const Center(
                            child: Text(
                              'Dinheiro insuficiente!',
                              style: TextStyle(fontSize: 20),
                            ),
                          )
                  ],
                ),
              ),
      ),
    );
  }
}
