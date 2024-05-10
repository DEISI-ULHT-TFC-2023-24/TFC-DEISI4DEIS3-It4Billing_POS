import 'package:flutter/material.dart';
import 'package:it4billing_pos/main.dart';

class DisplayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtém o conteúdo do primeiro template da base de dados
    final templates = database.getAllTemplates();
    String templateContent = templates.isNotEmpty ? templates[0].content : '';

    // Define um mapa com o valor de todas as variáveis
    Map<String, dynamic> variaveis = {
      'nome': 'Rafael',
      'local': 'Lisboa'
      // Adicione mais variáveis conforme necessário
    };

    // Função para substituir todas as ocorrências das variáveis no texto
    templateContent = substituirVariaveis(templateContent, variaveis);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conteúdo do Arquivo'),
      ),
      body: Center(
        child: templates.isNotEmpty ?
        Text(
          templateContent,
          softWrap: true,
        ) :
        Text('Faz upload de um ficheiro .txt'),
      ),
    );
  }

  // Função para substituir todas as ocorrências das variáveis no texto
  String substituirVariaveis(String texto, Map<String, dynamic> variaveis) {
    variaveis.forEach((chave, valor) {
      texto = texto.replaceAll('\${$chave}', valor.toString());
    });
    return texto;
  }
}
