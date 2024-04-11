import 'package:flutter/material.dart';
import '../../main.dart';
import '../../objetos/setupObj.dart';

class PreferenciasPage extends StatefulWidget {
  @override
  _PreferenciasPageState createState() => _PreferenciasPageState();
}

class _PreferenciasPageState extends State<PreferenciasPage> {
  SetupObj setup = database.getAllSetup()[0];

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
        ? Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Imprimir documento'),
                      trailing: Switch(
                        activeTrackColor: const Color(0xff00afe9),
                        activeColor: Colors.white,
                        value: setup.imprimir,
                        onChanged: (value) {
                          setState(() {
                            setup.imprimir = value;
                            database.addSetup(setup);
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Enviar por email'),
                      trailing: Switch(
                        activeTrackColor: const Color(0xff00afe9),
                        activeColor: Colors.white,
                        value: setup.email,
                        onChanged: (value) {
                          setState(() {
                            setup.email = value;
                            database.addSetup(setup);
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Emitir nota de credito'),
                      trailing: Switch(
                        activeTrackColor: const Color(0xff00afe9),
                        activeColor: Colors.white,
                        value: setup.notaCredito,
                        onChanged: (value) {
                          setState(() {
                            setup.notaCredito = value;
                            database.addSetup(setup);
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Dispositivo principal'),
                      trailing: Switch(
                        activeTrackColor: const Color(0xff00afe9),
                        activeColor: Colors.white,
                        value: setup.dispositivoPrincipal,
                        onChanged: (value) {
                          setState(() {
                            setup.dispositivoPrincipal = value;
                            database.addSetup(setup);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Preferencias'),
              backgroundColor: const Color(0xff00afe9),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Imprimir documento'),
                      trailing: Switch(
                        activeTrackColor: const Color(0xff00afe9),
                        activeColor: Colors.white,
                        value: setup.imprimir,
                        onChanged: (value) {
                          setState(() {
                            setup.imprimir = value;
                            database.addSetup(setup);
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Enviar por email'),
                      trailing: Switch(
                        activeTrackColor: const Color(0xff00afe9),
                        activeColor: Colors.white,
                        value: setup.email,
                        onChanged: (value) {
                          setState(() {
                            setup.email = value;
                            database.addSetup(setup);
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Emitir nota de credito'),
                      trailing: Switch(
                        activeTrackColor: const Color(0xff00afe9),
                        activeColor: Colors.white,
                        value: setup.notaCredito,
                        onChanged: (value) {
                          setState(() {
                            setup.notaCredito = value;
                            database.addSetup(setup);
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Dispositivo principal'),
                      trailing: Switch(
                        activeTrackColor: const Color(0xff00afe9),
                        activeColor: Colors.white,
                        value: setup.dispositivoPrincipal,
                        onChanged: (value) {
                          setState(() {
                            setup.dispositivoPrincipal = value;
                            database.addSetup(setup);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
