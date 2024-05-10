import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
//import 'package:image/image.dart';
import 'package:intl/intl.dart';
import 'package:it4billing_pos/objetos/impressoraObj.dart';
import 'dart:io';

import '../../../main.dart';
import '../configuracoes.dart';
import 'impressoras.dart';

class CriarImpressoraPage extends StatefulWidget {
  @override
  _CriarImpressoraPageState createState() => _CriarImpressoraPageState();
}

class _CriarImpressoraPageState extends State<CriarImpressoraPage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController ipController = TextEditingController();
  final TextEditingController portController = TextEditingController();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Impressora'),
        backgroundColor: const Color(0xff00afe9),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome da Impressora',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: ipController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Endereço IP da Impressora',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: portController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Porta da Impressora',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Ação para testar a impressão
                final ip = ipController.text;
                final int port = int.parse(portController.text);

                // Connect to printer and print QR code
                const PaperSize paper = PaperSize.mm80;
                final profile = await CapabilityProfile.load();
                final printer = NetworkPrinter(paper, profile);

                final PosPrintResult res = await printer.connect(ip, port: port);

                if (res == PosPrintResult.success) {
                  printer.text('Teste', styles: const PosStyles(align: PosAlign.center, bold: true));
                  printer.text('-----------------------------------------------', styles: const PosStyles(align: PosAlign.center));
                  printer.text('\nFatura-recibo de teste\n',
                      styles: const PosStyles(height: PosTextSize.size2, width: PosTextSize.size2,align: PosAlign.center
                      ));
                  printer.text('-----------------------------------------------', styles: const PosStyles(align: PosAlign.center));
                  printer.text('${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}\n', styles: const PosStyles(align: PosAlign.left));
                  printer.qrcode('https://www.it4billing.com/', size: QRSize.Size8);
                  printer.feed(2);
                  printer.cut();
                  printer.disconnect();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff00afe9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.black),
                ),
              ),
              child: const Text('Testar Impressão'),
            ),
            const Spacer(),
            SizedBox(
              height: 50.0,
              child: ElevatedButton(
                onPressed: () {
                  // Adicionar ação para guardar a impressora
                  String nome = nomeController.text;
                  String ip = ipController.text;
                  int port = int.parse(portController.text);
                  ImpressoraObj impressora = ImpressoraObj(nome, ip, port);
                  database.addImpressora(impressora);
                  Navigator.pop(context);

                  if(isTablet){
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ConfiguracoesPage()));
                  } else{
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ImpressorasPage()));
                  }

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff00afe9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: const BorderSide(color: Colors.black),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'GUARDAR',
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
