import 'package:flutter/material.dart';
import 'package:it4billing_pos/Paginas/Configuracoes/configuracoes.dart';
import 'package:it4billing_pos/Paginas/Login/loginPage.dart';
import 'package:it4billing_pos/Paginas/Turnos/turnoFechado.dart';
import 'package:it4billing_pos/Paginas/artigos.dart';
import 'package:it4billing_pos/Paginas/categorias.dart';
import 'package:it4billing_pos/Paginas/Login/setupPage.dart';
import 'package:it4billing_pos/Paginas/Vendas/vendas.dart';
import 'package:it4billing_pos/Paginas/Turnos/turno.dart';
import 'package:it4billing_pos/Paginas/Pedidos/pedidos.dart';
import 'dart:async';
import 'database/objectbox_database.dart';

late ObjectBoxDatabase database;

Future<void> main() async {
  // Isso é necessário para que a ObjectBox possa obter o diretório da aplicação
  // para armazenar o banco de dados.
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

    //pagina = '/turno'; /// TESTES

    return MaterialApp(
      title: 'it4billing_pos',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: pagina,
      // Trocar depois quando funcionar bem
      routes: {
        '/setupPage': (context) => const SetupPage(),
        '/loginPage': (context) => LoginPage(),
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
