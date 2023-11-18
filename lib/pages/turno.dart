import 'package:flutter/material.dart';
import '../navbar.dart';

class Turno extends StatelessWidget {
  const Turno({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: const NavBar(),
    appBar: AppBar(
      title: const Text('Turno'),
      backgroundColor: const Color(0xff00afe9),
    ),
    body: const Center(
      child: Text(
        'Pagina TURNOS',
        style: TextStyle(fontSize: 40.0),
      ),
    ),
  );
}
