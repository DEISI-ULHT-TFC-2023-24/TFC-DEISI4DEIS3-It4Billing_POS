import 'package:flutter/material.dart';
import 'package:it4billing_pos/navbar.dart';

class Vendas extends StatefulWidget {
  const Vendas({Key? key}) : super(key: key);

  @override
  State<Vendas> createState() => _Vendas();
}

class _Vendas  extends State<Vendas>{
  List<String> vendas = [];
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
                // Adiciona um novo objeto à lista quando o botão é pressionado
                setState(() {
                  vendas.add('Novo Objeto ${vendas.length + 1}');
                });
              },
              child: const Text('Criar Novo Objeto'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: vendas.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(vendas[index]),
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
