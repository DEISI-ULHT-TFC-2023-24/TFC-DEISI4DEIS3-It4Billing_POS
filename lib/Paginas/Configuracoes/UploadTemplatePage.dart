import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../main.dart';
import '../../objetos/templateOBJ.dart';
import 'DisplayTESTE.dart';

class UploadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload de Arquivo'),
        backgroundColor: const Color(0xff00afe9),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Verifica se a permissão de leitura de armazenamento externo está concedida
                var status = await Permission.storage.status;
                if (status.isGranted) {
                  // A permissão está concedida, abre o seletor de arquivos
                  openFilePicker(context);
                } else {
                  // A permissão não está concedida, solicita-a ao usuário
                  if (status.isPermanentlyDenied) {
                    // Se a permissão foi negada permanentemente, abre as configurações do aplicativo
                    openAppSettings();
                  } else {
                    // Solicita a permissão de leitura de armazenamento externo
                    var result = await Permission.storage.request();
                    if (result.isGranted) {
                      // A permissão foi concedida, abre o seletor de arquivos
                      openFilePicker(context);
                    }
                  }
                }
              },
              child: Text('Fazer Upload de Arquivo'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navega para a página de exibição
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DisplayPage(),
                  ),
                );
              },
              child: Text('Ver Arquivo Salvo'),
            ),
          ],
        ),
      ),
    );
  }

  void openFilePicker(BuildContext context) async {
    try {
      // Faz o upload do arquivo .txt
      final result = await FlutterDocumentPicker.openDocument();
      if (result != null) {
        // Verifica se o arquivo é do tipo .txt pelo nome do arquivo
        if (result.endsWith('.txt')) {
          // Lê o conteúdo do arquivo
          final fileContent = await File(result).readAsString();

          // Salva o conteúdo do arquivo no banco de dados
          final template = TemplateOBJ(fileContent);
          database.removeAllTemplate();
          database.addTemplate(template);

          // Mostra mensagem de sucesso
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Arquivo salvo com sucesso!'),
            ),
          );
        } else {
          // Se o arquivo selecionado não for .txt
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
        // Se o usuário cancelou a seleção
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
      // Em caso de erro, mostra uma mensagem de erro
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
