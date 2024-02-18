import 'package:flutter/material.dart';
import 'package:it4billing_pos/pages/artigos.dart';
import 'package:it4billing_pos/pages/categorias.dart';
import 'package:it4billing_pos/pages/loginPage.dart';
import 'package:it4billing_pos/pages/vendas.dart';
import 'package:it4billing_pos/pages/turno.dart';
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
    return MaterialApp(
      title: 'it4billing_pos',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/pedidos',  // Trocar depois quando funcionar bem
      routes: {
        '/loginPage': (context) => const LoginPage(),
        '/pedidos': (context) => Pedidos(pedidos: [],),
        '/turno': (context) => Turnos(pedidos: [],),
        '/vendas': (context) => Vendas(pedidos: [],),
        '/artigos': (context) =>  Artigos(pedidos: [],),
        '/categorias': (context) =>  Categorias(pedidos:[],),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
