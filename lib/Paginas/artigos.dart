import 'package:flutter/material.dart';
import 'package:it4billing_pos/objetos/turnoObj.dart';
import 'package:it4billing_pos/Paginas/Turnos/turno.dart';
import 'package:it4billing_pos/Paginas/Vendas/vendas.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import '../objetos/artigoObj.dart';
import '../objetos/setupObj.dart';
import 'Pedidos/pedidos.dart';
import 'Turnos/turnoFechado.dart';
import 'categorias.dart';
import 'Configuracoes/configuracoes.dart';

class ArtigosPage extends StatelessWidget {
  List<Artigo> artigos = database.getAllArtigos();
  TurnoObj turno = database.getAllTurno()[0];
  SetupObj setup = database.getAllSetup()[0];

  ArtigosPage({Key? key}) : super(key: key);

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
              database.getFuncionario(turno.funcionarioID)!.nome,
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
            Text(
              setup.nomeLoja,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            Text(
              setup.pos,
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
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => PedidosPage()));
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
                if (turno.turnoAberto) {
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

  Widget buildArtigoItem(BuildContext context, Artigo artigo) {
    final bool isVertical =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Container(
      padding: const EdgeInsets.all(10),
      // Aumentando o espaçamento interno
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      // Aumentando o espaçamento externo
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
                  artigo.nome.length > (isVertical ? 15 : 50)
                      ? artigo.nome.substring(0, isVertical ? 15 : 50)
                      : artigo.nome,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Referencia: ${artigo.referencia}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 200,
            // Definindo uma largura fixa para o bloco de informações de estoque e preço
            child: Row(
              children: [
                const SizedBox(width: 15),
                Text(
                  'Stock: ${artigo.stock}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 15),
                Text(
                  'Preço: ${artigo.price.toStringAsFixed(2)} €',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
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
        title: const Text('Artigos'),
        backgroundColor: const Color(0xff00afe9),
      ),
      body: ListView.builder(
        itemCount: artigos.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              const SizedBox(height: 20),
              buildArtigoItem(context, artigos[index])
            ],
          );
        },
      ),
    );
  }
}
