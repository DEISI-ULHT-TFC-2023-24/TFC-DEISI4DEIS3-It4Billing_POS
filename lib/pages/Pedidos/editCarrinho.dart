import 'package:flutter/material.dart';
import 'package:it4billing_pos/pages/Pedidos/carrinho.dart';

import '../../objetos/artigoObj.dart';
import '../../objetos/categoriaObj.dart';
import '../../objetos/pedidoObj.dart';

class EditCarrinho extends StatefulWidget {
  final Artigo artigo;
  int quantidade;
  late int qunatidadeInicial;
  List<PedidoObj> pedidos = [];
  List<Categoria> categorias = [];
  List<Artigo> artigos = [];
  PedidoObj pedido;

  EditCarrinho({
    Key? key,
    required this.artigo,
    required this.quantidade,
    required this.pedidos,
    required this.categorias,
    required this.artigos,
    required this.pedido,
  }) : super(key: key);

  @override
  _EditCarrinhoState createState() => _EditCarrinhoState();
}

class _EditCarrinhoState extends State<EditCarrinho> {
  TextEditingController _controllerP = TextEditingController();
  TextEditingController _controllerD = TextEditingController();
  bool _updatedP = false;
  bool _updatedD = false;

  @override
  void initState() {
    super.initState();
    widget.qunatidadeInicial = widget.quantidade;
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
      widget.artigo.price = novoPreco;
    });
  }

  void _aplicarDesconto() {
    double novoPreco = widget.artigo.price - double.parse(_controllerD.text);
    setState(() {
      widget.artigo.price = novoPreco;
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
      print(widget.quantidade);
      print(widget.pedido.nrArtigos);

      if (widget.quantidade > widget.qunatidadeInicial){
        for (int i = widget.qunatidadeInicial; i < widget.quantidade; i++) {
          widget.pedido.artigosPedidoIds.add(widget.artigo.id);
        }
        print('incrementa');
      }

      if (widget.quantidade < widget.qunatidadeInicial) {
        for (int i = widget.quantidade; i < widget.qunatidadeInicial; i++) {
          widget.pedido.artigosPedidoIds.remove(widget.artigo.id);
        }
        print('descrementa');
      }

    });
  print(widget.pedido.artigosPedidoIds);
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
                    decoration: const InputDecoration(
                      hintText: 'Digite as suas observações...\n\n\n\n\n\n',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: null, // ou qualquer valor maior que 1
                    onChanged: (value) {
                      setState(() {
                        widget.artigo.observacoes = value;
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
                                categorias: widget.categorias,
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
                                categorias: widget.categorias,
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
