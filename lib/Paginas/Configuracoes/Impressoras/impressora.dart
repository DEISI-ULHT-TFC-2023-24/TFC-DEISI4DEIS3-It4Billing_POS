import 'package:flutter/material.dart';
import 'package:it4billing_pos/objetos/impressoraObj.dart';
import 'dart:convert';
import 'dart:io';

import '../../../main.dart';
import 'impressoras.dart';

class ImpressoraPage extends StatefulWidget {
  late ImpressoraObj impressora;

  ImpressoraPage({
    Key? key,
    required this.impressora,
  }) : super(key: key);

  @override
  _ImpressoraPageState createState() => _ImpressoraPageState();
}

class _ImpressoraPageState extends State<ImpressoraPage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController ipController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Definir os valores dos controladores quando a página é carregada
    nomeController.text = widget.impressora.nome;
    ipController.text = widget.impressora.iP;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.impressora.nome),
        backgroundColor: const Color(0xff00afe9),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: nomeController,
              decoration: InputDecoration(
                labelText: 'Nome da Impressora',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: ipController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Endereço IP da Impressora',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Adicionar ação para testar a impressão

                final ip = ipController.text;
                const port = 9100;
                /// Aqui perceber como mandar imprimir alguma coisa ????

                try {
                  // Conectando à impressora
                  Socket socket = await Socket.connect(ip, port);

                  // Enviando dados de impressão
                  socket.write('Teste de Impressão\n\n\n\n\n\n\n\n\n');

                  // Enviando comando de corte
                  List<int> cutCommand = [0x1D, 0x56, 0x01];
                  socket.add(cutCommand);

                  // Finalizando conexão
                  await socket.flush();
                  await socket.close();
                } catch (e) {
                  print('Erro ao imprimir: $e');
                }

              },
              child: const Text('Testar Impressão'),
            ),
            Spacer(),
            SizedBox(
              height: 50.0,
              child: ElevatedButton(
                onPressed: () {
                  // Adicionar ação para eliminar a impressora
                  database.removeImpressora(widget.impressora.id);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ImpressorasPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Alterado para vermelho
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: const BorderSide(color: Colors.black),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'ELIMINAR', // Alterado de 'GUARDAR' para 'ELIMINAR'
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nomeController.dispose();
    ipController.dispose();
    super.dispose();
  }
}
