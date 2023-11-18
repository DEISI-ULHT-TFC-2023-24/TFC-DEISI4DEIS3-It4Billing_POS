import 'package:flutter/material.dart';
import 'package:it4billing_pos/pages/turno.dart';
import 'package:it4billing_pos/pages/vendas/vendas.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ),
      );

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
              'Id do dispositivo',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            Text(
              'Utilizador',
              style: TextStyle(fontSize: 12, color: Colors.white),
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
              leading: const Icon(Icons.shopping_basket_outlined),
              title: const Text('Vendas'),
              onTap: () {
                Navigator.popUntil(
                    context, ModalRoute.withName('/vendas'));
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time_outlined),
              title: const Text('Turno'),
              onTap: () {
                Navigator.popUntil(
                    context, ModalRoute.withName('/vendas'));
                Navigator.pushNamed(context, '/turno');
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text('Recibos'),
              onTap: () {
                Navigator.popUntil(
                    context, ModalRoute.withName('/vendas'));
                Navigator.pushNamed(context, '/recibos');
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_outlined),
              title: const Text('Artigos'),
              onTap: () {
                Navigator.popUntil(
                    context, ModalRoute.withName('/vendas'));
                Navigator.pushNamed(context, '/recibos');
              },
            ),

            const Divider(color: Colors.black54),

            ListTile(
              leading: const Icon(Icons.bar_chart_outlined),
              title: const Text('Back office'),
              onTap: () {
                Navigator.popUntil(
                    context, ModalRoute.withName('/vendas'));
                Navigator.pushNamed(context, '/recibos');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configurações'),
              onTap: () {
                Navigator.popUntil(
                    context, ModalRoute.withName('/vendas'));
                Navigator.pushNamed(context, '/recibos');
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Suporte'),
              onTap: () {
                Navigator.popUntil(
                    context, ModalRoute.withName('/vendas'));
                Navigator.pushNamed(context, '/recibos');
              },
            ),

          ],
        ),
      );
}
