import 'package:flutter/material.dart';
import 'package:it4billing_pos/pages/artigos.dart';
import 'package:it4billing_pos/pages/categorias.dart';
import 'package:it4billing_pos/pages/loginPage.dart';
import 'package:it4billing_pos/pages/vendas.dart';
import 'package:it4billing_pos/pages/turno.dart';
import 'package:it4billing_pos/pages/Pedidos/pedidos.dart';

void main() {
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
        '/pedidos': (context) => Pedidos(vendas: [],),
        '/turno': (context) => Turnos(vendas: [],),
        '/vendas': (context) => Vendas(vendas: [],),
        '/artigos': (context) =>  Artigos(vendas: [],),
        '/categorias': (context) =>  Categorias(vendas:[],),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
