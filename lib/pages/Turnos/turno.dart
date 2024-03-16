import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:it4billing_pos/pages/Turnos/fecharTurno.dart';

import 'package:it4billing_pos/pages/artigos.dart';
import 'package:it4billing_pos/pages/categorias.dart';
import 'package:it4billing_pos/pages/Vendas/vendas.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../main.dart';
import '../../objetos/metodoPagamentoObj.dart';
import '../../objetos/pedidoObj.dart';
import '../../objetos/setupObj.dart';
import '../../objetos/turnoObj.dart';
import '../Pedidos/pedidos.dart';
import '../Configuracoes/configuracoes.dart';
import 'gestaoDinheiro.dart';

class TurnosPage extends StatefulWidget {
  @override
  _TurnosPageState createState() => _TurnosPageState();
}

class _TurnosPageState extends State<TurnosPage> {
  List<PedidoObj> pedidos = database.getAllPedidos();
  List<MetodoPagamentoObj> metodos = database.getAllMetodosPagamento();
  SetupObj setup = database.getAllSetup()[0];
  late TurnoObj turno;

  @override
  void initState() {
    super.initState();
    turno = database.getAllTurno()[0];
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
          database.getUtilizador(setup.funcionarioId)!.nome,
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
    turno = database.getAllTurno()[0];
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
                child:

                ElevatedButton(
                  onPressed: () {
                    // Ação do botão "GESTÃO DO DINHEIRO NA GAVETA"
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GestaoDinheiro()),
                    ).then((_) {
                      // Atualizar a instância de turno após retornar da página de gestão de dinheiro
                      setState(() {
                        turno = database.getAllTurno()[0];
                      });
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xff00afe9),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xff00afe9)),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const FittedBox(
                    child: Text('GESTÃO DO DINHEIRO NA GAVETA', style: TextStyle(fontSize: 16)),
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
                    child: Text( database.getUtilizador(turno.funcionarioID)!.nome,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                  // Espaço vazio proporcional ao tamanho da tela
                  Expanded(
                    flex: 1,
                    child: Text( DateFormat('dd/MM/yyyy HH:mm')
                        .format(turno.horaAbertura),
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
                  const Text(
                    'Resumo de vendas',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color(0xff00afe9),
                    ),
                  ),
                  const SizedBox(height: 8),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Vendas brutas',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text( '${turno.vendasBrutas.toStringAsFixed(2)} €',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  _gap(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Reembolsos'),
                      Text('${turno.reembolsos.toStringAsFixed(2)} €'),
                    ],
                  ),
                  _gap(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Descontos'),
                      Text('${turno.descontos.toStringAsFixed(2)} €'),
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
                      const Text(
                        'Vendas líquidas',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('${turno.vendasliquidas.toStringAsFixed(2)} €',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: metodos.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(metodos[index].nome),
                            Text('${metodos[index].valor.toStringAsFixed(2)} €'),
                          ],
                        ),
                      );
                    },
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
                  const Text(
                    'Gaveta do dinheiro',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color(0xff00afe9),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Dinheiro inicial'),
                      Text('${turno.dinheiroInicial.toStringAsFixed(2)} €'),
                    ],
                  ),
                  _gap(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Pagamentos em dinheiro'),
                      Text('${turno.pagamentosDinheiro.toStringAsFixed(2)} €'),
                    ],
                  ),
                  _gap(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Reembolsos em dinheiro'),
                      Text('${turno.reembolsosDinheiro.toStringAsFixed(2)} €'),
                    ],
                  ),
                  _gap(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Suprimento'),
                      Text('${turno.suprimento.toStringAsFixed(2)} €'),
                    ],
                  ),
                  _gap(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Sangria'),
                      Text('${turno.sangria.toStringAsFixed(2)} €'),
                    ],
                  ),
                  _gap(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Quantidade de dinheiro esperado',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('${turno.dinheiroEsperado.toStringAsFixed(2)} €',
                        style: const TextStyle(
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
