import 'package:flutter/material.dart';
import '../../navbar.dart';

class Categorias extends StatelessWidget {
  const Categorias({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: const NavBar(),
    appBar: AppBar(
      title: const Text('Categorias'),
      backgroundColor: const Color(0xff00afe9),
    ),
    body: const Column(
      children: [

      ],
    ),
  );
}
