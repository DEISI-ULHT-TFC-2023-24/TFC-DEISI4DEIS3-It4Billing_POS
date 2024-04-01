import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:it4billing_pos/main.dart';
import 'package:it4billing_pos/objetos/turnoObj.dart';
import 'package:it4billing_pos/Paginas/Turnos/turno.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../objetos/setupObj.dart';
import '../Pedidos/pedidos.dart';
import '../artigos.dart';
import '../categorias.dart';
import '../Configuracoes/configuracoes.dart';
import '../Vendas/vendas.dart';

class TurnoFechado extends StatelessWidget {
  final TextEditingController valorInicialController = TextEditingController();
  TurnoObj turno = database.getAllTurno()[0];
  SetupObj setup = database.getAllSetup()[0];

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Chamando unfocus para perder o foco do campo de entrada
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Introduza o valor do dinheiro que está na sua gaveta no início do turno:',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: TextFormField(
                controller: valorInicialController, // Controlador adicionado aqui
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.center,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d+\.?\d{0,2}'),
                  ),
                ],
                decoration: const InputDecoration(
                  hintText: '0.00 €',
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: SizedBox(
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Lógica para abrir o turno aqui

                        turno.turnoAberto = true;
                        if (valorInicialController.text == ''){
                          valorInicialController.text = '0';
                        }

                        turno.dinheiroInicial = double.parse(valorInicialController.text); // Valor do controlador adicionado aqui
                        await database.removeAllTurno();
                        database.addTurno(turno);
                        print('Esta aberto? DEVIA!! -> ${database.getAllTurno()[0].turnoAberto}');



                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => TurnosPage()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff00afe9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: const BorderSide(color: Colors.black),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'ABRIR TURNO',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
