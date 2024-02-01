import 'package:flutter/material.dart';
import '../navbar.dart';

class Vendas extends StatelessWidget {
  const Vendas ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: const NavBar(),
        appBar: AppBar(
          title: const Text('Vendas concluídas'),
          backgroundColor: const Color(0xff00afe9),
        ),
        body: const Column(
          children: [

          ],
        ),
      );
}
