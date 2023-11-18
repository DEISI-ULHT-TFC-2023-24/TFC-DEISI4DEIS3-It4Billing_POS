import 'package:flutter/material.dart';

import '../navbar.dart';

class Recibos extends StatelessWidget {
  const Recibos ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: const NavBar(),
    appBar: AppBar(
      title: const Text('Recibos'),
      backgroundColor: const Color(0xff00afe9),
    ),
    body: const Center(
      child: Text(
        'Pagina Recibos',
        style: TextStyle(fontSize: 40.0),
      ),
    ),
  );
}
