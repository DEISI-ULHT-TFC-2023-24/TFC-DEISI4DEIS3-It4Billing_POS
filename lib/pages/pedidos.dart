import 'package:flutter/material.dart';
import 'package:it4billing_pos/pages/pedido.dart';
import '../navbar.dart';
import 'artigos.dart';
import 'package:it4billing_pos/objetos/vendaObj.dart';
import 'package:it4billing_pos/objetos/artigoObj.dart';
import 'package:it4billing_pos/objetos/categoriaObj.dart';
import 'package:it4billing_pos/pages/artigos.dart';

class Pedidos extends StatefulWidget {
  const Pedidos({Key? key}) : super(key: key);

  @override
  State<Pedidos> createState() => _Pedidos();
}

class _Pedidos extends State<Pedidos> {
  List<VendaObj> vendas = [];
  List<Categoria> categorias = [
    Categoria(nome: "Categoria 1", nomeCurto: "Cat 1", description: ''),
    Categoria(nome: "Categoria 2", nomeCurto: "Cat 2", description: ''),
    Categoria(nome: "Categoria 3", nomeCurto: "Cat 3", description: ''),
  ];
  List<Artigo> artigos = [];

  getcat() {
    artigos = [
      Artigo(
          referencia: "001",
          nome: "Artigo 1",
          categoria: categorias[0],
          barCod: '',
          description: '',
          productType: '',
          unitPrice: 1,
          idArticlesCategories: 1,
          taxPrecentage: 1,
          idTaxes: 1,
          taxName: '',
          taxDescription: '',
          idRetention: 1,
          retentionPercentage: 1,
          retentionName: ''),
      Artigo(
          referencia: "002",
          nome: "Artigo 2",
          categoria: categorias[2],
          barCod: '',
          description: '',
          productType: '',
          unitPrice: 2,
          idArticlesCategories: 2,
          taxPrecentage: 2,
          idTaxes: 2,
          taxName: '',
          taxDescription: '',
          idRetention: 2,
          retentionPercentage: 2,
          retentionName: ''),
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
          title: const Text('Pedidos'),
          backgroundColor: const Color(0xff00afe9),
        ),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(
                        builder: (context) => Pedido(
                              artigos: artigos,
                              categorias: categorias,
                              vendas: vendas,
                            )));

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
                      onPressed: () {}, child: Text(vendas[index].nome));
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
