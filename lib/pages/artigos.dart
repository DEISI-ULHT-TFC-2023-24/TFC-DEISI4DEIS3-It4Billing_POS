import 'package:flutter/material.dart';
import '../navbar.dart';

class Artigos extends StatelessWidget {
  const Artigos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: const NavBar(),
    appBar: AppBar(
      title: const Text('Artigos'),
      backgroundColor: const Color(0xff00afe9),
    ),
    body: const Column(
      children: [

      ],
    ),
  );
}
