import 'package:flutter/material.dart';
import '../../main.dart';
import '../../objetos/setupObj.dart';

class PreferenciasPage extends StatefulWidget {
  @override
  _PreferenciasPageState createState() => _PreferenciasPageState();
}

class _PreferenciasPageState extends State<PreferenciasPage> {
  SetupObj setup = database.getAllSetup()[0];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  value: setup.email,
                  onChanged: (value) {
                    setState(() {
                      setup.email = value;
                      print(setup.email);
                      database.addSetup(setup);
                      print(database.getAllSetup().length);
                      print(database.getAllSetup()[0].email);

                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Emitir nota de credito'),
                trailing: Switch(
                  value: setup.notaCredito,
                  onChanged: (value) {
                    setState(() {
                      setup.notaCredito = value;
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
