import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:it4billing_pos/objetos/impressoraObj.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';


import '../../../main.dart';
import '../configuracoes.dart';
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
  final TextEditingController portController = TextEditingController();
  bool camposAlterados = false; // Adicione esta variável
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
  void initState() {
    super.initState();
    // Definir os valores dos controladores quando a página é carregada
    nomeController.text = widget.impressora.nome;
    ipController.text = widget.impressora.iP;
    portController.text = widget.impressora.port.toString();

    // Adicione listeners aos controladores para detectar alterações nos campos
    nomeController.addListener(() {
      if (nomeController.text != widget.impressora.nome ||
          ipController.text != widget.impressora.iP ||
          portController.text != widget.impressora.port.toString()) {
        setState(() {
          camposAlterados = true;
        });
      } else {
        setState(() {
          camposAlterados = false;
        });
      }
    });

    ipController.addListener(() {
      if (nomeController.text != widget.impressora.nome ||
          ipController.text != widget.impressora.iP ||
          portController.text != widget.impressora.port.toString()) {
        setState(() {
          camposAlterados = true;
        });
      } else {
        setState(() {
          camposAlterados = false;
        });
      }
    });

    portController.addListener(() {
      if (nomeController.text != widget.impressora.nome ||
          ipController.text != widget.impressora.iP ||
          portController.text != widget.impressora.port.toString()) {
        setState(() {
          camposAlterados = true;
        });
      } else {
        setState(() {
          camposAlterados = false;
        });
      }
    });
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
              decoration: const InputDecoration(
                labelText: 'Nome da Impressora',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: ipController,
              keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Endereço IP da Impressora',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: portController,
              keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Porta da Impressora',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Ação para testar a impressão
                final ip = ipController.text;
                final int port = int.parse(portController.text);

                try {
                  // Conectando à impressora
                  Socket socket = await Socket.connect(ip, port);

                  // Comando para centralizar o texto
                  final centralizarTexto = [0x1B, 0x61, 0x01];

                  // Comando para ativar negrito
                  final ativarNegrito = [0x1B, 0x45, 0x01];

                  // Comando para desativar negrito
                  final desativarNegrito = [0x1B, 0x45, 0x00];

                  // Comando para aumentar o tamanho da fonte
                  final aumentarFonte = [0x1D, 0x21, 0x09];

                  // Comando para definir o tamanho da fonte
                  final tamanhoFonte = [0x1B, 0x21, 0x00]; // Define o tamanho da fonte para o padrão


                  // Comando para descentralizar o texto (definir alinhamento padrão)
                  final alinhamentoPadrao = [0x1B, 0x61, 0x00];


                  // Texto a ser enviado
                  final texto = '\nTeste\n\n';

                  // Concatenando os comandos e o texto
                  final tituloCentrado = [...ativarNegrito,...centralizarTexto,...utf8.encode(texto), ...alinhamentoPadrao, ...desativarNegrito];

                  // Comando para imprimir separador de linha de traços
                  final separador = '-----------------------------------------------\n';

                  // Comandos para imprimir a frase "Fatura-recibo de teste"
                  const frase = '\nFatura-recibo de teste\n\n';
                  // Concatenando os comandos e o texto
                  final fraseCentrada = [...ativarNegrito,...centralizarTexto, ...aumentarFonte, ...utf8.encode(frase), ...alinhamentoPadrao, ...desativarNegrito, ...tamanhoFonte];

                  // Comandos para imprimir a data e hora do sistema
                  final dataHora = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());


                  // Enviar comandos para a impressora
                  socket.add(tituloCentrado);
                  socket.write(separador);
                  socket.add(fraseCentrada);
                  socket.write(separador);
                  socket.write(dataHora);

                  // Enviando dados de impressão
                  socket.write('\n\n\n\n\n\n\n');

                  // Enviando comando de corte
                  List<int> cutCommand = [0x1D, 0x56, 0x01];
                  socket.add(cutCommand);

                  await socket.flush();
                  await socket.close();
                } catch (e) {
                  print('Erro ao imprimir: $e');
                }
              },
              child: const Text('Testar Impressão'),
            ),
            const SizedBox(height: 20),
            const Spacer(),
            Visibility( // Adicione a visibilidade com base em camposAlterados
              visible: camposAlterados,
              child: Column(
                children: [
                  SizedBox(
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () {
                        // Adicionar ação para guardar a impressora
                        String nome = nomeController.text;
                        String ip = ipController.text;
                        int port = int.parse(portController.text);
                        ImpressoraObj impressora = ImpressoraObj(nome, ip, port);
                        database.removeImpressora(widget.impressora.id);
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
            SizedBox(
              height: 50.0,
              child: ElevatedButton(
                onPressed: () {
                  // Adicionar ação para eliminar a impressora
                  database.removeImpressora(widget.impressora.id);
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
    portController.dispose();
    super.dispose();
  }
}
