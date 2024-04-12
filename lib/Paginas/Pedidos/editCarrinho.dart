import 'package:flutter/material.dart';
import 'package:it4billing_pos/Paginas/Pedidos/carrinho.dart';

import '../../objetos/artigoObj.dart';
import '../../objetos/pedidoObj.dart';

class EditCarrinho extends StatefulWidget {
  final Artigo artigo;
  int quantidade;
  late int qunatidadeInicial;
  List<PedidoObj> pedidos = [];
  List<Artigo> artigos = [];
  PedidoObj pedido;

  EditCarrinho({
    Key? key,
    required this.artigo,
    required this.quantidade,
    required this.pedidos,
    required this.artigos,
    required this.pedido,
  }) : super(key: key);

  @override
  _EditCarrinhoState createState() => _EditCarrinhoState();
}

class _EditCarrinhoState extends State<EditCarrinho> {
  TextEditingController _controllerP = TextEditingController();
  TextEditingController _controllerD = TextEditingController();
  late TextEditingController _observacoesController;

  bool _updatedP = false;
  bool _updatedD = false;

  @override
  void initState() {
    super.initState();
    widget.qunatidadeInicial = widget.quantidade;
    _observacoesController = TextEditingController(text: widget.artigo.observacoes);
  }

  @override
  void dispose() {
    // Lembre-se de descartar o TextEditingController quando não for mais necessário para evitar vazamentos de memória.
    _observacoesController.dispose();
    super.dispose();
  }

  void _increment() {
    setState(() {
      // adicionar alguma verificação para não passar o stock existente+
      widget.quantidade++;
    });
  }

  void _decrement() {
    setState(() {
      if (widget.quantidade > 1) {
        widget.quantidade--;
      }
    });
  }

  void _atualizarPreco() {
    ///ADICIONAR UMA VERIFICAÇÃO
    double novoPreco = double.parse(_controllerP.text);
    setState(() {
      widget.artigo.unitPrice = novoPreco/(1+(widget.artigo.taxPrecentage/100));
      widget.artigo.price = novoPreco;
      if (widget.pedido.artigosPedido.contains(widget.artigo)){
        widget.pedido.artigosPedido.remove(widget.artigo);
        widget.pedido.artigosPedido.add(widget.artigo);
      }

    });
  }

  void _aplicarDesconto() {
    double novoPreco = widget.artigo.price - double.parse(_controllerD.text);
    setState(() {
      widget.artigo.discount = widget.artigo.price - novoPreco;
      widget.artigo.unitPrice = novoPreco/(1+(widget.artigo.taxPrecentage/100));
      widget.artigo.price = novoPreco;
      if (widget.pedido.artigosPedido.contains(widget.artigo)){
        widget.pedido.artigosPedido.remove(widget.artigo);
        widget.pedido.artigosPedido.add(widget.artigo);
      }
    });
  }

  void removerArtigo() {
    setState(() {
      for (int i = 0; i < widget.quantidade; i++) {
        widget.pedido.nrArtigos--;
        widget.pedido.artigosPedidoIds.remove(widget.artigo.id);
      }
    });
  }

  void gravar(){
    setState(() {

      if (widget.quantidade > widget.qunatidadeInicial){
        for (int i = widget.qunatidadeInicial; i < widget.quantidade; i++) {
          widget.pedido.artigosPedidoIds.add(widget.artigo.id);
        }
        //incrementa
      }

      if (widget.quantidade < widget.qunatidadeInicial) {
        for (int i = widget.quantidade; i < widget.qunatidadeInicial; i++) {
          widget.pedido.artigosPedidoIds.remove(widget.artigo.id);
        }
        //descrementa
      }

    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(widget.artigo.nome),
        backgroundColor: const Color(0xff00afe9),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 30),
            const Text('Quantidade', style: TextStyle(fontSize: 20.0)),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: _decrement,
                  ),
                  Text(
                    '${widget.quantidade}',
                    style: const TextStyle(fontSize: 20.0),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _increment,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controllerP,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Preço',
                            hintText: '${widget.artigo.price}',
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
// Espaçamento entre os elementos
                      SizedBox(
                        width: 110,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _atualizarPreco();
                              _updatedP = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _updatedP
                                ? Colors.grey
                                : const Color(0xff00afe9),
                          ),
                          child: Text(
                              _updatedP ? 'Atualizado' : 'Atualizar'),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controllerD,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              labelText: 'Desconto', hintText: '0.00'),
                        ),
                      ),
                      SizedBox(width: 20),
// Espaçamento entre os elementos
                      SizedBox(
                        width: 110,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _aplicarDesconto();
                              _updatedD = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _updatedD
                                ? Colors.grey
                                : const Color(0xff00afe9),
                          ),
                          child: Text(_updatedD ? 'Aplicado' : 'Aplicar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Observações:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _observacoesController,
                    decoration: const InputDecoration(
                      hintText: 'Digite as suas observações...\n\n\n\n\n\n',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: null, // ou qualquer valor maior que 1
                    onChanged: (value) {
                      setState(() {
                        widget.artigo.observacoes = value;
                        widget.pedido.artigosPedido.add(widget.artigo);
                      });
                    },
                  ),
                ],
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
                      '${(widget.artigo.price * widget.quantidade).toStringAsFixed(2)} €',
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
                    padding:
                    const EdgeInsets.only(left: 20.0, bottom: 30),
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          removerArtigo();
                          Navigator.of(context).pop();
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => CarrinhoPage(
                                pedidos: widget.pedidos,
                                artigos: widget.artigos,
                                pedido: widget.pedido,),
                          ));
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
                            'ELIMINAR',
                            style: TextStyle(
                                color: Colors.black, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20), // Espaço entre os botões
                Expanded(
                  child: Padding(
                    padding:
                    const EdgeInsets.only(right: 20.0, bottom: 30),
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                            // adicionar o nomero de vezes a mais na lista dos artigos no carrinho ou retirar
                            // meu deus que confusão...
                          gravar();
                          Navigator.of(context).pop();
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => CarrinhoPage(
                                pedidos: widget.pedidos,
                                artigos: widget.artigos,
                                pedido: widget.pedido,),
                          ));

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
                            'GRAVAR',
                            style: TextStyle(
                                color: Colors.white, fontSize: 18),
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
      ));
}
