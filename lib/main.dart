import 'package:flutter/material.dart';
import 'package:it4billing_pos/pages/loginPage.dart';
import 'package:it4billing_pos/pages/recibos.dart';
import 'package:it4billing_pos/pages/turno.dart';
import 'package:it4billing_pos/pages/vendas/venda.dart';
import 'package:it4billing_pos/pages/vendas/vendas.dart';

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
      initialRoute: '/vendas',  // Trocar depois quando funcionar bem
      routes: {
        '/loginPage': (context) => const LoginPage(),
        '/vendas': (context) => Vendas(),
        '/venda': (context) => const Venda(),
        '/turno': (context) => const Turno(),
        '/recibos': (context) => const Recibos(),

      },
      debugShowCheckedModeBanner: false,
    );
  }
}
