import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../objetos/impressoraObj.dart';
import 'impressora.dart';
import 'newImpressora.dart';

class ImpressorasPage extends StatefulWidget {
  @override
  _ImpressorasPageState createState() => _ImpressorasPageState();
}

class _ImpressorasPageState extends State<ImpressorasPage> {
  List<ImpressoraObj> impressoras = database.getAllImpressoras();
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
              child: Text('Conteúdo da Página de Impressoras'),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Página de Impressoras'),
              backgroundColor: const Color(0xff00afe9),
            ),
            body: impressoras.isNotEmpty
                ? ListView.builder(
                    itemCount: impressoras.length,
                    itemBuilder: (context, index) {
                      final impressora = impressoras[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // Adicione a ação desejada quando o botão for pressionado
                            print('Botão da impressora ${impressora.nome} pressionado');
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ImpressoraPage(impressora: impressora,)));
                          },
                          child: Text(impressora.nome),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.print,
                          size: 100,
                          color: Colors.blue,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Ainda não existe nenhuma impressora',
                          style: TextStyle(fontSize: 17),
                        ),
                        Text(
                          'Para adicionar uma impressora clique no botão (+)',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CriarImpressoraPage()));
              },
              child: Icon(Icons.add),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          );
  }
}