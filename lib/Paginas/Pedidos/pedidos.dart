import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:it4billing_pos/objetos/setupObj.dart';
import 'package:it4billing_pos/objetos/turnoObj.dart';
import 'package:it4billing_pos/Paginas/Pedidos/pedido.dart';
import 'package:it4billing_pos/Paginas/Pedidos/pedidoAberto.dart';
import 'package:it4billing_pos/objetos/pedidoObj.dart';
import 'package:it4billing_pos/objetos/artigoObj.dart';
import 'package:it4billing_pos/objetos/categoriaObj.dart';

import '../../main.dart';
import '../Turnos/turnoFechado.dart';
import '../artigos.dart';
import '../categorias.dart';
import '../Turnos/turno.dart';
import '../Configuracoes/configuracoes.dart';
import '../Vendas/vendas.dart';

class PedidosPage extends StatefulWidget {
  List<PedidoObj> pedidos = database.getAllPedidos();
  TurnoObj turno = database.getAllTurno()[0];
  SetupObj setup = database.getAllSetup()[0];

  PedidosPage({
    Key? key,
  }) : super(key: key);

  @override
  State<PedidosPage> createState() => _PedidosPage();
}

class _PedidosPage extends State<PedidosPage> {

  Widget buildHeader(BuildContext context) => Container(
        color: const Color(0xff00afe9),
        padding: EdgeInsets.only(
          top: 50 + MediaQuery.of(context).padding.top,
          left: 20,
          bottom: 50,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              database.getFuncionario(widget.setup.funcionarioId)!.nome,
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
            Text(
              widget.setup.nomeLoja,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            Text(
              widget.setup.pos,
              style: const TextStyle(fontSize: 18, color: Colors.white),
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
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => VendasPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time_outlined),
              title: const Text('Turno'),
              onTap: () {
                Navigator.pop(context);
                if (widget.turno.turnoAberto) {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TurnosPage()));
                } else {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TurnoFechado()));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_outlined),
              title: const Text('Artigos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ArtigosPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.label_outline),
              title: const Text('Categorias'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CategoriasPage()));
              },
            ),
            const Divider(color: Colors.black54),
            ListTile(
              leading: const Icon(Icons.bar_chart_outlined),
              title: const Text('Back office'),
              onTap: () {
                Navigator.pop(context);
                _launchURL('https://app.it4billing.com/Login');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configurações'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ConfiguracoesPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Suporte'),
              onTap: () {
                Navigator.pop(context);
                _launchURL('https://www.it4billing.com/suporte/');
              },
            ),
          ],
        ),
      );

  _launchURL(String url) async {
    try {
      final uri = Uri.parse(url);
      await launchUrl(uri);
    } catch (e) {
      print('Erro ao lançar a URL: $e');
    }
  }

  Future<bool?> showMyDialog(BuildContext context) => showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Quer sair da aplicação?"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('NÃO')),
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

  void carregarClientes() {
    if (database.getAllClientes().isEmpty) {
      database.putDemoClientes();
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

  void carregarTurno() {
    widget.turno = database.getAllTurno()[0];
  }

  @override
  void initState() {
    super.initState();

    carregarTurno();
    carregarPedidos();
    carregarLocais();
    carregarClientes();
    carregarCategorias();
    carregarArtigos();
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
                                    builder: (context) => PedidoPage(
                                          categorias:
                                              database.getAllCategorias(),
                                          pedidos: widget.pedidos,
                                        )));
                          },
                          style: ButtonStyle(
                            side: MaterialStateProperty.all(
                                const BorderSide(color: Colors.black)),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            fixedSize:
                                MaterialStateProperty.all(const Size(800, 80)),
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
                  widget.pedidos.isEmpty
                      ? const Expanded(
                          child: Center(
                              child: Text('Não existem pedidos abertos',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ))))
                      : Expanded(
                          child: ListView.builder(
                            itemCount: widget.pedidos.length,
                            itemBuilder: (context, index) {
                              return Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 50),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PedidoAbertoPage(
                                                    artigos: database.getAllArtigos(),
                                                    categorias: database.getAllCategorias(),
                                                    pedidos: widget.pedidos,
                                                    pedido: widget.pedidos[index],
                                                  )));
                                    },
                                    style: ButtonStyle(
                                      side: MaterialStateProperty.all(
                                          const BorderSide(
                                              color: Colors.black)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                      fixedSize: MaterialStateProperty.all(
                                          const Size(300, 80)),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                database
                                                    .getLocal(widget
                                                        .pedidos[index]
                                                        .localId)!
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
                                            'Funcionario: ${database.getFuncionario(widget.pedidos[index].funcionarioID)?.nome}',
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
                          backgroundColor: const Color(0xff00afe9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: const BorderSide(color: Colors.black),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text('ABRIR TURNO',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              )),
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
