import 'package:flutter/material.dart';
import 'package:it4billing_pos/navbar.dart';
import 'package:it4billing_pos/pages/vendas/venda.dart';

import 'vendaObj.dart';
import 'artigo.dart';
import 'categoria.dart';

class Vendas extends StatefulWidget {
  Vendas({Key? key}) : super(key: key);

  @override
  State<Vendas> createState() => _Vendas();
}

class _Vendas extends State<Vendas> {
  List<VendaObj> vendas = [];
  List<Categoria> categorias = [
    Categoria(nome: "Categoria 1", nomeCurto: "Cat 1"),
    Categoria(nome: "Categoria 2", nomeCurto: "Cat 2"),
    Categoria(nome: "Categoria 3", nomeCurto: "Cat 3"),
  ];
  List<Artigo> artigos = [];

  getcat() {
    artigos = [
      Artigo(
          nome: "Artigo 1",
          referencia: "001",
          unidade: "kg",
          categoria: categorias[0]),
      Artigo(
          nome: "Artigo 2",
          referencia: "011",
          unidade: "un",
          categoria: categorias[2])
    ];
  }

  // criar lista com cat teste para enviar para a proxima pagina e ai fazer os objetos consuante o numero de coisas
  // fazer tbm o ecra sub cat (no mesmo ecra )
  // tendo a lista do objetos tbm criada aqui  fazer a cena de selecionar e ai ter o botao que faz add na lista de vendas

  @override
  Widget build(BuildContext context) => WillPopScope(
      child: Scaffold(
        drawer: const NavBar(),
        appBar: AppBar(
          title: const Text('Vendas'),
          backgroundColor: const Color(0xff00afe9),
        ),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: () {

                Navigator.push(context, MaterialPageRoute(builder: (context) => Venda(artigos: artigos,categorias: categorias,vendas: vendas,)));

                // Adiciona um novo objeto à lista quando o botão é pressionado
                //setState(() {
                //  vendas.add(VendaObj(nome: "venda 2"));
                //});
              },
              child: const Text('Criar Novo Objeto'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: vendas.length,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                      onPressed: () {},
                      child: Text(vendas[index].nome));
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
            title: const Text(" Quer sair da aplicação"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('CANCELAR')),
              TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('SIM'))
            ],
          ));
}
