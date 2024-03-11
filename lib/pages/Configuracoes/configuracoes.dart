import 'package:flutter/material.dart';
import 'package:it4billing_pos/pages/artigos.dart';
import 'package:it4billing_pos/pages/Turnos/turno.dart';
import 'package:it4billing_pos/pages/vendas.dart';
import '../../main.dart';
import '../../objetos/VendaObj.dart';
import '../../objetos/setupObj.dart';
import '../../objetos/turnoObj.dart';
import '../Pedidos/pedidos.dart';
import '../Turnos/turnoFechado.dart';
import '../categorias.dart';
import 'exposocaoCliente.dart';
import 'geral.dart';
import 'impressoras.dart';

class ConfiguracoesPage extends StatelessWidget {
  List<VendaObj> vendas = database.getAllVendas();
  TurnoObj turno = database.getAllTurnos()[0];
  SetupObj setup = database.getAllSetup()[0];

  ConfiguracoesPage({Key? key}) : super(key: key);

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
          database.getUtilizador(setup.utilizadorID)!.nome,
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
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configurações'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Suporte'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );

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
        title: const Text('Configurações'),
        backgroundColor: const Color(0xff00afe9),
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Geral'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => GeralPage()));
              },
            ),
            Divider(), // Linha divisória
            ListTile(
              leading: const Icon(Icons.print),
              title: const Text('Impressoras'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImpressorasPage()));
              },
            ),
            Divider(), // Linha divisória
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Exposição do Cliente'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ExposicaoPage()));
              },
            ),
            Divider(), // Linha divisória
          ],
        ),
      ),
    );
  }

}
