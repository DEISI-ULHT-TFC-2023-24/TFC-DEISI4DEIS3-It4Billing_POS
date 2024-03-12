import 'package:flutter/material.dart';
import 'package:it4billing_pos/objetos/setupObj.dart';
import 'package:it4billing_pos/pages/Configuracoes/configuracoes.dart';
import 'package:it4billing_pos/pages/Login/loginPage.dart';
import 'package:it4billing_pos/pages/Turnos/turnoFechado.dart';
import 'package:it4billing_pos/pages/artigos.dart';
import 'package:it4billing_pos/pages/categorias.dart';
import 'package:it4billing_pos/pages/Login/setupPage.dart';
import 'package:it4billing_pos/pages/Vendas/vendas.dart';
import 'package:it4billing_pos/pages/Turnos/turno.dart';
import 'package:it4billing_pos/pages/Pedidos/pedidos.dart';
import 'dart:async';
import 'database/objectbox_database.dart';

late ObjectBoxDatabase database;

Future<void> main() async {
  // This is required so ObjectBox can get the application directory
  // to store the database in.
  WidgetsFlutterBinding.ensureInitialized();

  database = await ObjectBoxDatabase.create();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String pagina = '/setupPage';
    print(database.getAllSetup().length);
    if (database.getAllSetup().isNotEmpty) {
      if (database.getAllSetup()[0].url == '' ||
          database.getAllSetup()[0].password == '') {
        // não fazer nada
      } else {
        pagina = '/loginPage';
      }
    }

    //pagina = '/cliente'; /// TESTES

    return MaterialApp(
      title: 'it4billing_pos',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: pagina,
      // Trocar depois quando funcionar bem
      routes: {
        '/setupPage': (context) => const SetupPage(),
        '/loginPage': (context) => LoginPage(
              setup: SetupObj(),
            ),
        '/cofig': (context) => ConfiguracoesPage(),
        '/pedidos': (context) => PedidosPage(),
        '/turno': (context) => TurnosPage(),
        '/turnoF': (context) => TurnoFechado(),
        '/vendas': (context) => VendasPage(),
        '/artigos': (context) => ArtigosPage(),
        '/categorias': (context) => CategoriasPage(),
        //'/cliente': (context) => AdicionarClientePage(),
        '/config': (context) => ConfiguracoesPage()


      },
      debugShowCheckedModeBanner: false,
    );
  }
}
