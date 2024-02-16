import 'dart:io';

import 'package:flutter/material.dart';
import 'package:it4billing_pos/pages/Pedidos/pedido.dart';
import 'package:it4billing_pos/pages/Pedidos/pedidoAberto.dart';
import 'package:it4billing_pos/objetos/pedidoObj.dart';
import 'package:it4billing_pos/objetos/artigoObj.dart';
import 'package:it4billing_pos/objetos/categoriaObj.dart';

import '../../objetos/localObj.dart';
import '../artigos.dart';
import '../categorias.dart';
import '../turno.dart';
import '../vendas.dart';

class Pedidos extends StatefulWidget {
  late List<PedidoObj> pedidos = [];
  List<String> metodosPagamento = ['DINHEIRO','MULTIBANCO','MB WAY'];


  Pedidos({
    Key? key,
    required this.pedidos,
  }) : super(key: key);

  List<String> getMetodosPagamento(){
    return metodosPagamento;
  }

  @override
  State<Pedidos> createState() => _Pedidos();
}

class _Pedidos extends State<Pedidos> {
  // contruir ainda a forma como tratar a info da base de dados e perceber como vou receber API's e etc..
  // ainda a data para a base de dados





  List<Categoria> categorias = [
    Categoria(nome: 'Todos os artigos', description: '', nomeCurto: ''),
    Categoria(nome: "Categoria 1", nomeCurto: "Cat 1", description: ''),
    Categoria(nome: "Categoria 2", nomeCurto: "Cat 2", description: ''),
    Categoria(nome: "Categoria 3", nomeCurto: "Cat 3", description: ''),
  ];
  List<Artigo> artigos = [];
  List<LocalObj> locais = [
    LocalObj('Local 1'),
    LocalObj('Local 2'),
    LocalObj('Local 3'),
  ];

  getcat() {
    artigos = [
      Artigo(
          referencia: "001",
          nome: "Artigo 1",
          barCod: '',
          description: '',
          productType: '',
          unitPrice: 4.06,
          idArticlesCategories: 1,
          categoria: categorias[1],
          taxPrecentage: 23,
          idTaxes: 1,
          taxName: '',
          taxDescription: '',
          idRetention: 1,
          retentionPercentage: 1,
          retentionName: '',
          stock: 56),
      Artigo(
          referencia: "002",
          nome: "Artigo 2",
          barCod: '',
          description: '',
          productType: '',
          unitPrice: 6.42,
          idArticlesCategories: 2,
          categoria: categorias[2],
          taxPrecentage: 23,
          idTaxes: 2,
          taxName: '',
          taxDescription: '',
          idRetention: 2,
          retentionPercentage: 2,
          retentionName: '',
          stock: 10),
      Artigo(
          referencia: "003",
          nome: "Artigo 3 com um nome grande PARA TESTES",
          barCod: '',
          description: '',
          productType: '',
          unitPrice: 1,
          idArticlesCategories: 2,
          categoria: categorias[3],
          taxPrecentage: 23,
          idTaxes: 2,
          taxName: '',
          taxDescription: '',
          idRetention: 2,
          retentionPercentage: 2,
          retentionName: '',
          stock: 10),
    ];
  }


  // criar lista com cat teste para enviar para a proxima pagina e ai fazer os objetos consuante o numero de coisas
  // fazer tbm o ecra sub cat (no mesmo ecra )
  // tendo a lista do objetos tbm criada aqui  fazer a cena de selecionar e ai ter o botao que faz add na lista de vendas

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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Vendas(pedidos: widget.pedidos)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time_outlined),
              title: const Text('Turno'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Turnos(pedidos: widget.pedidos)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_outlined),
              title: const Text('Artigos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Artigos(pedidos: widget.pedidos)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.label_outline),
              title: const Text('Categorias'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Categorias(pedidos: widget.pedidos)));
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
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 20 + MediaQuery.of(context).padding.top,
                bottom: 20,
              ),
              child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  child: ElevatedButton(
                    onPressed: () {
                      getcat();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Pedido(
                                    artigos: artigos,
                                    categorias: categorias,
                                    pedidos: widget.pedidos,
                                    locais: locais
                                  )));
                      // Adiciona um novo objeto à lista quando o botão é pressionado
                    },
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                          const BorderSide(color: Colors.black)),
                      // Linha de borda preta
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      // Fundo transparente
                      fixedSize:
                          MaterialStateProperty.all(const Size(8000, 80)),
                      // Tamanho fixo de 270x80
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                          getcat();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PedidoAberto(
                                      artigos: artigos,
                                      categorias: categorias,
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
                          fixedSize:
                              MaterialStateProperty.all(const Size(300, 80)),
                          // Tamanho fixo de 270x80
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        child:


                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center, // Centraliza verticalmente
                            //crossAxisAlignment: CrossAxisAlignment.center, // Centraliza horizontalmente
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alinha a Row horizontalmente ao centro
                                children: [
                                  Text(
                                    widget.pedidos[index].local.nome,
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
                                'Funcionario: ${widget.pedidos[index].funcionario.nome}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),



                      )
                  );
                },
              ),
            ),
          ],
        ),
      ),
      onWillPop: () async {
        final shouldPop = await showMyDialog(context);
        return shouldPop ?? false;
      });

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
}
