import 'package:flutter/material.dart';
import 'package:it4billing_pos/pages/Turnos/turno.dart';
import 'package:it4billing_pos/pages/vendas.dart';
import '../main.dart';
import '../objetos/categoriaObj.dart';
import 'Pedidos/pedidos.dart';
import 'artigos.dart';

class Categorias extends StatelessWidget {
  List<Categoria> categorias = database.getAllCategorias();

  Categorias({Key? key }) : super(key: key);

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
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Vendas()));
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
          },
        ),

        const Divider(color: Colors.black54),

        ListTile(
          leading: const Icon(Icons.bar_chart_outlined),
          title: const Text('Back office'),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/recibos');
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Configurações'),
          onTap: () {
            Navigator.pushReplacementNamed(context,'/recibos');
          },
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('Suporte'),
          onTap: () {
            Navigator.pushReplacementNamed(context,'/recibos');
          },
        ),
      ],
    ),
  );

  Widget buildArtigoItem(BuildContext context, Categoria categoria) {
    final bool isVertical = MediaQuery.of(context).orientation == Orientation.portrait;

    return Container(
      padding: const EdgeInsets.all(10), // Aumentando o espaçamento interno
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0), // Aumentando o espaçamento externo
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12), // Aumentando o raio da borda
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  categoria.nome.length > (isVertical ? 20 : 50)
                      ? categoria.nome.substring(0, isVertical ? 20 : 50)
                      : categoria.nome,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5,),
                Text(
                  categoria.nomeCurto,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 15),
              Text(
                'Nº de artigos: ${categoria.nrArtigos}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: const Text('Categorias'),
        backgroundColor: const Color(0xff00afe9),
      ),
      body: ListView.builder(
        itemCount: categorias.length - 1,
        itemBuilder: (context, index) {
          return Column(
            children: [
              const SizedBox(height: 20),
              buildArtigoItem(context, categorias[index + 1])
            ],
          );

        },
      ),
    );
  }
}