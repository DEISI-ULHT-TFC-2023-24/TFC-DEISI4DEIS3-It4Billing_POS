import 'package:flutter/material.dart';

class ExposicaoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página de Exposição do Cliente'),backgroundColor: const Color(0xff00afe9),
      ),
      body: Center(
        child: Text('Conteúdo da Página de Exposição do Cliente'),
      ),
    );
  }
}
