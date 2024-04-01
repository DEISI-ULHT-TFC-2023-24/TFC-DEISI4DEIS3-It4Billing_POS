import 'package:flutter/material.dart';
import 'package:it4billing_pos/Paginas/artigos.dart';
import 'package:it4billing_pos/Paginas/Turnos/turno.dart';
import 'package:it4billing_pos/Paginas/Vendas/vendas.dart';
import 'package:url_launcher/url_launcher.dart';
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
import 'preferencias.dart';

class ConfiguracoesPage extends StatefulWidget {
  @override
  _ConfiguracoesPageState createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  List<VendaObj> vendas = database.getAllVendas();
  TurnoObj turno = database.getAllTurno()[0];
  SetupObj setup = database.getAllSetup()[0];

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.app_settings_alt_outlined),
                  title: const Text('Geral'),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => GeralPage()));
                  },
                ),
                Divider(), // Linha divisória
                ListTile(
                  leading: const Icon(Icons.local_print_shop_outlined),
                  title: const Text('Impressoras'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ImpressorasPage()));
                  },
                ),
                Divider(), // Linha divisória
                ListTile(
                  leading: const Icon(Icons.display_settings_outlined),
                  //
                  title: const Text('Exposição do Cliente'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ExposicaoPage()));
                  },
                ),
                Divider(),
                ListTile(
                  leading: const Icon(Icons.settings_input_component_outlined),//),
                  title: const Text('Preferencias'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PreferenciasPage()));
                  },
                ),
                Divider(), // Linha divisória
              ],
            ),

          ],
        ),
      ),
    );
  }

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
          database.getFuncionario(setup.funcionarioId)!.nome,
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
          title: const Text('Vendas concluídas'),
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
}
