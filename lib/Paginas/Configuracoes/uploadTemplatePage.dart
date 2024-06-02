import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import '../../objetos/templateOBJ.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload de Arquivo'),
        backgroundColor: const Color(0xff00afe9),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.upload_file_outlined,
              size: 100,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await handleUploadButtonPressed();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff00afe9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.black),
                ),
              ),
              child: const Text('Fazer Upload de Arquivo',style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 20),
            database.getAllTemplates().isEmpty
                ? const Text('Último Upload: Nunca')
                : Text('Último Upload:  ${DateFormat('dd/MM/yyyy HH:mm')
                .format(database.getAllTemplates()[0].hora)}')
          ],
        ),
      ),
    );
  }

  Future<void> handleUploadButtonPressed() async {
    try {
      final result = await FlutterDocumentPicker.openDocument();
      if (result != null) {
        if (result.endsWith('.txt')) {
          final fileContent = await File(result).readAsString();
          final template = TemplateOBJ(fileContent, DateTime.now());
          database.removeAllTemplate();
          database.addTemplate(template);
          // Atualize o estado para reconstruir o widget com a nova data
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Arquivo salvo com sucesso!'),
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Formato de arquivo inválido'),
              content: const Text('Por favor, selecione um arquivo .txt.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Nenhum arquivo selecionado'),
            content: Text('Por favor, selecione um arquivo .txt.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erro'),
          content: Text('Erro ao carregar o arquivo: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
