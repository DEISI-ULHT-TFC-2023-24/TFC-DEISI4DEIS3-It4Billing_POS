import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:it4billing_pos/pages/Turnos/fecharTurno.dart';

import 'package:it4billing_pos/pages/artigos.dart';
import 'package:it4billing_pos/pages/categorias.dart';
import 'package:it4billing_pos/pages/Vendas/vendas.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../main.dart';
import '../../objetos/pedidoObj.dart';
import '../../objetos/setupObj.dart';
import '../Pedidos/pedidos.dart';
import '../Configuracoes/configuracoes.dart';
import 'gestaoDinheiro.dart';

class TurnosPage extends StatelessWidget {
  List<PedidoObj> pedidos = database.getAllPedidos();
  SetupObj setup = database.getAllSetup()[0];

  TurnosPage({
    Key? key,
  }) : super(key: key);

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
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => PedidosPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text('Vendas concluidas'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => VendasPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time_outlined),
              title: const Text('Turno'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_outlined),
              title: const Text('Artigos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => ArtigosPage()));
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

  @override
  Widget build(BuildContext context) {
    bool isHorizontal =
        MediaQuery.of(context).orientation == Orientation.landscape;

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
        title: const Text('Turnos'),
        backgroundColor: const Color(0xff00afe9),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: isHorizontal ? 40.0 : 20.0), // Alteração aqui
              child: SizedBox(
                height: isHorizontal ? 45 : 40, // Altura fixa do botão
                child: ElevatedButton(
                  onPressed: () {
                    // Ação do botão "GESTÃO DO DINHEIRO NA GAVETA"
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GestaoDinheiro()));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xff00afe9), backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xff00afe9)),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const FittedBox(
                    child: Text('GESTÃO DO DINHEIRO NA GAVETA',
                        style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: isHorizontal ? 40.0 : 20.0), // Alteração aqui
              child: SizedBox(
                height: isHorizontal ? 45 : 40, // Altura fixa do botão
                child: ElevatedButton(
                  onPressed: () {
                    // Ação do botão "Fechar turno"
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => FecharTurno()));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xff00afe9), backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xff00afe9)),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const FittedBox(
                    child: Text('FECHAR TURNO', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: isHorizontal ? 40.0 : 20.0), // Alteração aqui
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Funcionário: João',
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                  // Espaço vazio proporcional ao tamanho da tela
                  Expanded(
                    flex: 1,
                    child: Text(
                      '03/03/2024 10:00',
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.black54),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: isHorizontal ? 40.0 : 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Resumo de vendas',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color(0xff00afe9),
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Vendas brutas',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '0.00 €',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  _gap(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Reembolsos'),
                      Text('0.00 €'),
                    ],
                  ),
                  _gap(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Descontos'),
                      Text('0.00 €'),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.black54),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: isHorizontal ? 40.0 : 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Vendas líquidas',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('0.00 €',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Dinheiro'),
                      Text('0.00 €'),
                    ],
                  ),
                  _gap(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Multibanco'),
                      Text('0.00 €'),
                    ],
                  ),
                  _gap(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('MB Way'),
                      Text('0.00 €'),
                    ],
                  ),
                  _gap(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Fazer a lista consuante o tipo de metudos'),
                      Text('999999.99 €'),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.black54),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: isHorizontal ? 40.0 : 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Gaveta do dinheiro',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color(0xff00afe9),
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Dinheiro inicial'),
                      Text('0.00 €'),
                    ],
                  ),
                  _gap(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Pagamentos em dinheiro'),
                      Text('0.00 €'),
                    ],
                  ),
                  _gap(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Reembolsos em dinheiro'),
                      Text('0.00 €'),
                    ],
                  ),
                  _gap(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Suprimento'),
                      Text('0.00 €'),
                    ],
                  ),
                  _gap(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Sangria'),
                      Text('0.00 €'),
                    ],
                  ),
                  _gap(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Quantidade de dinheiro esperado',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('0.00 €',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 8);
}
