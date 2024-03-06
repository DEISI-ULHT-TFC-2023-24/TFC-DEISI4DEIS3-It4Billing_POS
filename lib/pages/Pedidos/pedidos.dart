import 'dart:io';

import 'package:flutter/material.dart';
import 'package:it4billing_pos/objetos/turnoObj.dart';
import 'package:it4billing_pos/pages/Pedidos/pedido.dart';
import 'package:it4billing_pos/pages/Pedidos/pedidoAberto.dart';
import 'package:it4billing_pos/objetos/pedidoObj.dart';
import 'package:it4billing_pos/objetos/artigoObj.dart';
import 'package:it4billing_pos/objetos/categoriaObj.dart';

import '../../main.dart';
import '../Turnos/turnoFechado.dart';
import '../artigos.dart';
import '../categorias.dart';
import '../Turnos/turno.dart';
import '../vendas.dart';

class Pedidos extends StatefulWidget {
  List<PedidoObj> pedidos = database.getAllPedidos();
  TurnoObj turno = database.getAllTurnos()[0];

  List<String> metodosPagamento = ['DINHEIRO', 'MULTIBANCO', 'MB WAY'];

  Pedidos({
    Key? key,
  }) : super(key: key);

  List<String> getMetodosPagamento() {
    return metodosPagamento;
  }

  @override
  State<Pedidos> createState() => _Pedidos();
}

class _Pedidos extends State<Pedidos> {
  // contruir ainda a forma como tratar a info da base de dados e perceber como vou receber API's e etc..
  // ainda a data para a base de dados

  Widget buildHeader(BuildContext context) => Container(
        color: const Color(0xff00afe9),
        padding: EdgeInsets.only(
          top: 50 + MediaQuery.of(context).padding.top,
          left: 20,
          bottom: 50,
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Utilizador 01',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            Text(
              'Loja de Beja',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            Text(
              'POS 00',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      );

  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        child: Wrap(
          runSpacing: 5,
          children: [
            ListTile(
              leading: const Icon(Icons.shopping_cart_outlined),
              title: const Text('Pedidos'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text('Vendas concluidas'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Vendas()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time_outlined),
              title: const Text('Turno'),
              onTap: () {
                Navigator.pop(context);
                if (widget.turno.turnoAberto){
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Turnos()));
                } else {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => TurnoFechado()));
                }

              },
            ),
            ListTile(
              leading: const Icon(Icons.list_outlined),
              title: const Text('Artigos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Artigos()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.label_outline),
              title: const Text('Categorias'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Categorias()));
              },
            ),
            const Divider(color: Colors.black54),
            ListTile(
              leading: const Icon(Icons.bar_chart_outlined),
              title: const Text('Back office'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/recibos');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configurações'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/recibos');
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Suporte'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/recibos');
              },
            ),
          ],
        ),
      );

  Future<bool?> showMyDialog(BuildContext context) => showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Quer sair da aplicação?"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('CANCELAR')),
              TextButton(
                  onPressed: () {
                    exit(0);
                  },
                  child: const Text('SIM'))
            ],
          ));

  void carregarPedidos() {
    widget.pedidos = database.getAllPedidos();
  }

  void carregarLocais() {
    if (database.getAllLocal().isEmpty) {
      database.putDemoLocais();
    }
  }

  void carregarCategorias() {
    if (database.getAllCategorias().isEmpty) {
      database.putDemoCategorias();
    }
  }

  Future<void> carregarArtigosEAtualizarNrArtigosCategorias() async {
    List<Categoria> allCategorias = database.getAllCategorias();
    List<Artigo> allArtigos = database.getAllArtigos();

    for (Categoria categoria in allCategorias) {
      int nrArtigosCategoria = 0;
      for (Artigo artigo in allArtigos) {
        if (categoria.id == artigo.idArticlesCategories) {
          nrArtigosCategoria++;
        }
      }
      categoria.nrArtigos = nrArtigosCategoria;
      await database.addCategorias(categoria);
    }
  }

  void carregarArtigos() {
    if (database.getAllArtigos().isEmpty) {
      database.putDemoArtigos();
      carregarArtigosEAtualizarNrArtigosCategorias();
    }
  }

  Future<void> carregarUsers() async {
    if (database.getAllUtilizadores().isEmpty) {
      await database.putDemoUsers();
    }
    ;
  }

  void carregarTurno() {
    widget.turno = database.getAllTurnos()[0];
  }

  @override
  void initState() {
    super.initState();
    //print('Tamanho da lista de pedidos BD depois d vir do carrinho ${database.getAllPedidos().length}');

    carregarTurno();
    carregarPedidos();

    //print('Tamanho da lista de pedidos depois d vir do carrinho ${widget.pedidos.length}');
    if (widget.pedidos.isNotEmpty) {
      //print('id do primeiro pedido: ${widget.pedidos[0].id}');
    } else {
      print('Pedidos estam vazios');
    }

    carregarUsers();
    carregarLocais();
    carregarCategorias();
    carregarArtigos();

    print('Esta aberto? -> ${widget.turno.turnoAberto}');

  }

  @override
  Widget build(BuildContext context) => WillPopScope(
      child: Scaffold(
        drawer: Drawer(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                buildHeader(context),
                buildMenuItems(context),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: const Text('Pedidos'),
          backgroundColor: const Color(0xff00afe9),
        ),
        body: widget.turno.turnoAberto
            ? Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          database.removeAllPedidos();
                          carregarPedidos();
                          //database.removeAllArtigos();
                          //database.removeAllCategorias();
                        });
                      },
                      child: const Text('Limpar a lista para testes-')),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 20 + MediaQuery.of(context).padding.top,
                      bottom: 20,
                    ),
                    child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 50),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Pedido(
                                          categorias:
                                              database.getAllCategorias(),
                                          pedidos: widget.pedidos,
                                        )));
                            // Adiciona um novo objeto à lista quando o botão é pressionado
                          },
                          style: ButtonStyle(
                            side: MaterialStateProperty.all(
                                const BorderSide(color: Colors.black)),
                            // Linha de borda preta
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            // Fundo transparente
                            fixedSize:
                                MaterialStateProperty.all(const Size(800, 80)),
                            // Tamanho fixo de 270x80
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          child: const Text(
                            'NOVO PEDIDO',
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        )),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.pedidos.length,
                      itemBuilder: (context, index) {
                        return Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 50),
                            child: ElevatedButton(
                              onPressed: () {
                                // entrar dentro do pedido ainda aberto
                                print(widget.pedidos[index].nrArtigos);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PedidoAberto(
                                              artigos: database.getAllArtigos(),
                                              categorias:
                                                  database.getAllCategorias(),
                                              pedidos: widget.pedidos,
                                              pedido: widget.pedidos[index],
                                            )));
                              },
                              style: ButtonStyle(
                                side: MaterialStateProperty.all(
                                    const BorderSide(color: Colors.black)),
                                // Linha de borda preta
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                // Fundo white
                                fixedSize: MaterialStateProperty.all(
                                    const Size(300, 80)),
                                // Tamanho fixo de 270x80
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // Centraliza verticalmente
                                  //crossAxisAlignment: CrossAxisAlignment.center, // Centraliza horizontalmente
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      // Alinha a Row horizontalmente ao centro
                                      children: [
                                        Text(
                                          database
                                              .getLocal(widget
                                                  .pedidos[index].localId)!
                                              .nome,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Total: ${widget.pedidos[index].total.toStringAsFixed(2)} €',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Funcionario: ${database.getUtilizador(widget.pedidos[index].funcionarioID)?.nome} \n'
                                      'Artigos na lista: ${widget.pedidos[index].artigosPedidoIds.length}',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ));
                      },
                    ),
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.access_time_outlined,
                      size: 100,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Turno fechado',
                      style: TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Abra um turno para poder realizar novos pedidos.',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TurnoFechado()));
                      },
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xff00afe9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: const BorderSide(color: Colors.black),
                          ),
                        ),
                      child: const Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Text('ABRIR TURNO'),
                      ),
                    ),
                    ),

                  ],
                ),
              ),
      ),
      onWillPop: () async {
        final shouldPop = await showMyDialog(context);
        return shouldPop ?? false;
      });
}
