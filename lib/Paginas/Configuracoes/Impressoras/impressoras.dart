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
    final screenSize = MediaQuery.of(context).size;
    setState(() {
      isTablet = screenSize.width > 600 && screenSize.height > 600;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isTablet
        ? Scaffold(
            body: impressoras.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: ListView.builder(
                      itemCount: impressoras.length,
                      itemBuilder: (context, index) {
                        final impressora = impressoras[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(color: Colors.black),
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ImpressoraPage(
                                    impressora: impressora,
                                  ),
                                ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  impressora.nome,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
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
              child: const Icon(Icons.add),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Página de Impressoras'),
              backgroundColor: const Color(0xff00afe9),
            ),
            body: impressoras.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: ListView.builder(
                      itemCount: impressoras.length,
                      itemBuilder: (context, index) {
                        final impressora = impressoras[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(color: Colors.black),
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ImpressoraPage(
                                    impressora: impressora,
                                  ),
                                ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  impressora.nome,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
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
              child: const Icon(Icons.add),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          );
  }
}
