import 'package:flutter/material.dart';

class ExposicaoPage extends StatefulWidget {
  @override
  _ExposicaoPageState createState() => _ExposicaoPageState();
}

class _ExposicaoPageState extends State<ExposicaoPage> {
  bool isTablet = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    checkDeviceType();
  }

  void checkDeviceType() {
    // Getting the screen size
    final screenSize = MediaQuery.of(context).size;
    // Arbitrarily defining screen size greater than 600 width and height as tablet
    setState(() {
      isTablet = screenSize.width > 600 && screenSize.height > 600;
    });
  }

  @override
  Widget build(BuildContext context) {
    //isTablet ? TabletLayout() : PhoneLayout(),
    return isTablet
        ? const Scaffold(
            body: Center(
              child: Text('Conteúdo da Página de Exposição do Cliente'),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Página de Exposição do Cliente'),
              backgroundColor: const Color(0xff00afe9),
            ),
            body: const Center(
              child: Text('Conteúdo da Página de Exposição do Cliente'),
            ),
          );
  }
}
