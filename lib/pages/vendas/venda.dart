import 'package:flutter/material.dart';

import '../../navbar.dart';

class Venda extends StatelessWidget {
  const Venda({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Venda 01'),
      backgroundColor: const Color(0xff00afe9),
    ),
    body: const Center(
      child: Text(
        'Pagina Venda',
        style: TextStyle(fontSize: 40.0),
      ),
    ),
  );
}
