import 'package:flutter/material.dart';
import 'package:it4billing_pos/pages/artigos.dart';
import 'package:it4billing_pos/pages/Turnos/turno.dart';
import '../main.dart';
import '../objetos/pedidoObj.dart';
import 'Pedidos/pedidos.dart';
import 'categorias.dart';

class Vendas extends StatelessWidget {
  List<PedidoObj> pedidos = database.getAllPedidos();

  Vendas ({Key? key }) : super(key: key);

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
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Pedidos()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.receipt_long),
          title: const Text('Vendas concluidas'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.access_time_outlined),
          title: const Text('Turno'),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Turnos()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.list_outlined),
          title: const Text('Artigos'),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Artigos()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.label_outline),
          title: const Text('Categorias'),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Categorias()));
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
            Navigator.pushReplacementNamed(context,'/recibos');
          },
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('Suporte'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context,'/recibos');
          },
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
            title: const Text('Vendas concluídas'),
            backgroundColor: const Color(0xff00afe9),
          ),
          body: const Column(
            children: [

            ],
          ),

    );
  }
}
