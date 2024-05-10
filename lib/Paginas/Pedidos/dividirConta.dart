import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:it4billing_pos/Paginas/Pedidos/pedidos.dart';

import '../../main.dart';
import '../../objetos/VendaObj.dart';
import '../../objetos/artigoObj.dart';
import '../../objetos/impressoraObj.dart';
import '../../objetos/metodoPagamentoObj.dart';
import '../../objetos/meusArgumentos.dart';
import '../../objetos/pedidoObj.dart';
import '../../objetos/setupObj.dart';
import '../../objetos/turnoObj.dart';
import '../Cliente/addClientePage.dart';
import 'cobrarDividido.dart';

class DividirConta extends StatefulWidget {
  List<PedidoObj> pedidos = [];
  SetupObj setup = database.getAllSetup()[0];
  List<ImpressoraObj> impressoras = database.getAllImpressoras();
  late PedidoObj pedido;
  TurnoObj turno = database.getAllTurno()[0];

  DividirConta({
    Key? key,
    required this.pedidos,
    required this.pedido,
  }) : super(key: key);

  @override
  _DividirConta createState() => _DividirConta();
}

class _DividirConta extends State<DividirConta> {
  int numPessoas = 2; // Começa com dois
  List<double> valoresIndividuais = []; // Valores individuais de cada pessoa
  bool mostrarBotaoConcluir = false;
  List<MetudobotaoPressionado> botaoPressionado = [];
  late List<TextEditingController> controllers;
  List<int> listaMetudoUsados = [];
  late Map<int, int> artigosAgrupados;
  bool _showEmailField = false;
  TextEditingController _emailController = TextEditingController();

  Map<int, int> groupItems(List<int> listaIds) {
    Map<int, int> frequenciaIds = {};

    for (int id in listaIds) {
      if (frequenciaIds.containsKey(id)) {
        frequenciaIds[id] = (frequenciaIds[id] ?? 0) + 1;
      } else {
        frequenciaIds[id] = 1;
      }
    }

    return frequenciaIds;
  }

  @override
  void initState() {
    super.initState();
    _showEmailField = widget.setup.email;
    if (database.getCliente(widget.pedido.clienteID)!.email != 'N/D' ||
        database.getCliente(widget.pedido.clienteID)!.email != '') {
      _emailController.text = database.getCliente(widget.pedido.clienteID)!.email;
    }
    calcularValoresIndividuais();
    botaoPressionado = List.generate(numPessoas,
            (index) =>
            MetudobotaoPressionado(false, MetodoPagamentoObj('', 0)));

    // Inicialize os controllers e adicione listeners para limpar os campos quando ganharem foco
    controllers = List.generate(
      numPessoas,
          (index) {
        TextEditingController controller = TextEditingController(
          text: valoresIndividuais[index].toStringAsFixed(2),
        );
        controller.addListener(() {
          final text = controller.text;
          if (text.isNotEmpty) {
            valoresIndividuais[index] = double.parse(text);
          }
        });
        return controller;
      },
    );
  }

  @override
  void dispose() {
    // Dispose os controllers
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void calcularValoresIndividuais() {
    double totalPedido = widget.pedido.total;
    setState(() {
      valoresIndividuais.clear();
      double valorIndividual = double.parse((totalPedido / numPessoas).toStringAsFixed(2)); // Arredondar para 2 casas decimais
      double totalFixo = double.parse((valorIndividual * numPessoas).toStringAsFixed(2));
      double diferenca = totalPedido - totalFixo;
      double diferencaPorPessoa = (diferenca / 0.01).abs();

      for (int i = 0; i < numPessoas; i++) {
        double valor = valorIndividual;
        if (diferenca > 0 && diferencaPorPessoa > 0) {
          valor += 0.01;
          diferenca -= 0.01;
          diferencaPorPessoa--;
        }
        if (diferenca < 0 && diferencaPorPessoa > 0) {
          valor -= 0.01;
          diferenca += 0.01;
          diferencaPorPessoa--;
        }
        valoresIndividuais.add(double.parse(
            valor.toStringAsFixed(2))); // Garantir 2 casas decimais
      }

      // Ajuste para garantir que a soma seja igual ao total do pedido
      valoresIndividuais[0] += totalPedido -
          valoresIndividuais.reduce((value, element) => value + element);
    });
  }

  void aumentarPessoas() {
    setState(() {
      numPessoas++;
      botaoPressionado
          .add(MetudobotaoPressionado(false, MetodoPagamentoObj('', 0)));
      mostrarBotaoConcluir =
      false; // Se aumentar o número de pessoas, o botão "Concluir Venda" deve desaparecer
      controllers.add(TextEditingController());
      valoresIndividuais.add(0.0);
      listaMetudoUsados.add(0);
      calcularValoresIndividuais();
      // Atualize os controladores com os novos valores individuais
      for (int i = 0; i < numPessoas; i++) {
        controllers[i].text = valoresIndividuais[i].toStringAsFixed(2);
      }
    });
  }

  void diminuirPessoas() {
    if (numPessoas > 2) {
      setState(() {
        numPessoas--;
        botaoPressionado.removeLast();
        valoresIndividuais.removeLast();
        listaMetudoUsados.removeLast();
        controllers.removeLast();
        calcularValoresIndividuais();
        // Atualize os controladores com os novos valores individuais
        for (int i = 0; i < numPessoas; i++) {
          controllers[i].text = valoresIndividuais[i].toStringAsFixed(2);
        }
      });
    }
  }

  // Método para contar quantos botões foram pressionados
  int countPressedButtons() {
    return botaoPressionado
        .where((item) => item.pressionado)
        .length;
  }

  void cobrarValor(int index) {
    bool algumValorInvalido = false;
    double somaValores =
    valoresIndividuais.reduce((value, element) => value + element);

    if (double.parse((somaValores).toStringAsFixed(2)) <
        double.parse((widget.pedido.total).toStringAsFixed(2))) {
      algumValorInvalido = true;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Dinheiro insuficiente.'),
            content: const Text(
                'A soma dos valores cobrados é inferior ao total do pedido.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      for (int i = 0; i < valoresIndividuais.length; i++) {
        if (valoresIndividuais[i] < 0.00) {
          algumValorInvalido = true;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Valor inserido é inválido.'),
                content: const Text(
                    'Por favor, insira um valor válido para prosseguir com a cobrança.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }
    }

    if (!algumValorInvalido) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CobrarDivididoPage(
                pedido: widget.pedido,
                valorCobrar: valoresIndividuais[index],
              ),
        ),
      ).then((troca) {
        MeusArgumentos args = troca;
        if (args.meuBool) {
          setState(() {
            botaoPressionado[index].pressionado = args.meuBool;
            if (countPressedButtons() == numPessoas) {
              mostrarBotaoConcluir = true;
            }
          });
        }
        // retirar o dinheiro do metudo e atualizar o turno
        botaoPressionado[index].metodo = database.getMetodoPagamento(args.meuInt)!;
      });
    }
  }

  void concluirVenda() {
    // Lógica para concluir a venda
    VendaObj venda = VendaObj(
        nome: widget.pedido.nome,
        hora: widget.pedido.hora,
        funcionarioID: widget.pedido.funcionarioID,
        localId: widget.pedido.localId,
        total: widget.pedido.total);
    venda.artigosPedidoIds = widget.pedido.artigosPedidoIds;
    venda.nrArtigos = widget.pedido.nrArtigos;

    // Inclua a lógica para enviar por email e/ou imprimir com base nas escolhas do usuário
    if (widget.setup.email && _showEmailField) {
      // Enviar por email para _emailController.text
    }
    if (widget.setup.imprimir && database.getAllImpressoras().isNotEmpty) {
      // Chamar a função imprimir
      imprimir();
    }

    database.addVenda(venda);
    if (widget.pedido.id != 0) {
      if (database.getPedido(widget.pedido.id) != null) {
        database.removePedido(widget.pedido.id);
      }
    }

    database.getAllLocal().forEach((local) {
      if (local.id == widget.pedido.localId) {
        local.ocupado = false;
        database.addLocal(local);
      }
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PedidosPage(),
      ),
    );
  }



  Future<void> imprimir() async {
    ImpressoraObj impressora = widget.impressoras[0];
    // Dados demo da empresa
    final String nomeEmpresa = "It4Billing";
    final String moradaEmpresa = "Rua da Empresa, 123";
    final String cidadeEstado_CodigopostalEmpresa =
        "1234-678 - Cidade da Emprresa";
    final String telefoneEmpresa = "219876543";
    final String nifEmpresa = '502123456';

    try {
      // Conectando à impressora

      Socket socket = await Socket.connect(impressora.iP, impressora.port);

      // Comando para centralizar o texto
      final centralizarTexto = [0x1B, 0x61, 0x01];

      // Comando para ativar negrito
      final ativarNegrito = [0x1B, 0x45, 0x01];

      // Comando para desativar negrito
      final desativarNegrito = [0x1B, 0x45, 0x00];

      // Comando para aumentar o tamanho da fonte
      final aumentarFonte = [0x1B, 0x21, 0x20];

      // Define o tamanho da fonte para o padrão
      final tamanhoFonte = [0x1B, 0x21, 0x00];

      // Comando para descentralizar o texto (definir alinhamento padrão)
      final alinhamentoPadrao = [0x1B, 0x61, 0x00];

      // Texto a ser enviado
      final texto = '\n$nomeEmpresa\n\n';
      // Concatenando os comandos e o texto
      final tituloCentrado = [
        ...ativarNegrito,
        ...centralizarTexto,
        ...utf8.encode(texto),
        ...alinhamentoPadrao,
        ...desativarNegrito
      ];

      // Cabeçalho
      String cabecalho = '';

      // Informações da empresa
      cabecalho += '$moradaEmpresa\n';
      cabecalho += '$cidadeEstado_CodigopostalEmpresa\n';
      cabecalho += 'Tel: $telefoneEmpresa\n';
      cabecalho += 'NIF: $nifEmpresa\n\n';

      // Informações do cliente
      cabecalho +=
      'Cliente: ${database.getCliente(widget.pedido.clienteID)!.nome}\n';
      cabecalho += '${database.getCliente(widget.pedido.clienteID)!.address}\n';
      cabecalho +=
      'Cód. Postal: ${database.getCliente(widget.pedido.clienteID)!
          .postcode}\n';
      cabecalho +=
      'NIF: ${database.getCliente(widget.pedido.clienteID)!.NIF}\n';
      cabecalho +=
      'Tel: ${database.getCliente(widget.pedido.clienteID)!.phone}\n\n';
      cabecalho +=
      'Data de Emissao: ${DateFormat('dd/MM/yyyy HH:mm').format(
          DateTime.now())}\n';
      cabecalho +=
      'Vendador: ${database.getFuncionario(widget.setup.funcionarioId)!
          .nome}\n';

      // Comando para imprimir separador de linha de traços
      final separador = '------------------------------------------------\n';

      // Comandos para imprimir a frase "Fatura-recibo de teste"
      const fatura = 'FT XPTO/158\n';
      // Concatenando os comandos e o texto
      final faturaN = [
        ...ativarNegrito,
        ...utf8.encode(fatura),
        ...desativarNegrito
      ];

      final indice = 'Qtd.---IVA%-----Preco-------Desc.-------Total\n';
      // Convertendo o texto para UTF-8
      List<int> indiceUtf8Bytes = utf8.encode(indice);

      String pordutos = '';
      //                        id       Qtd
      artigosAgrupados.forEach((chave, valor) {
        // Verifica se o artigo está presente na lista
        for (Artigo artigoLista in widget.pedido.artigosPedido) {
          if (artigoLista.nome == database.getArtigo(chave)!.nome) {
            String nomeArtigo = artigoLista.nome.length > 40
                ? artigoLista.nome.substring(0, 40)
                : artigoLista.nome;
            //Valor representa a quantidade do produto
            pordutos +=
            '$valor     ${artigoLista.taxPrecentage}%      ${artigoLista.price
                .toStringAsFixed(2)}EUR     ${artigoLista.discount
                .toStringAsFixed(2)}EUR    ${(artigoLista.price * valor)
                .toStringAsFixed(2)}EUR\n'
                '$nomeArtigo\n';
            break;
          }
        }
      });
      // Convertendo o texto para UTF-8
      List<int> pordutosUtf8Bytes = utf8.encode(pordutos);

      String totalImp = '---------------Impostos Incluidos---------------\n\n';
      final totalImpE = [
        ...centralizarTexto,
        ...utf8.encode(totalImp),
      ];
      String total =
          'Total EURO ${widget.pedido.calcularValorTotal().toStringAsFixed(
          2)}\n\n';

      final totalCentrado = [
        ...ativarNegrito,
        ...aumentarFonte,
        ...utf8.encode(total),
        ...tamanhoFonte,
        ...alinhamentoPadrao,
        ...desativarNegrito
      ];

      final indiceImp = 'Detalhes do IVA\n\n'
          'Taxa  x  Incidencia   = Total Impos.\n';
      List<int> indiceImpUtf8Bytes = utf8.encode(indiceImp);

      Map<int, double> taxPercentageSumMap = {};

// Agrupando os artigos com base no valor de taxPrecentage e calculando a soma de unitPrice para cada grupo
      for (Artigo artigoLista in widget.pedido.artigosPedido) {
        int taxPercentage = artigoLista.taxPrecentage;
        double unitPrice = artigoLista.unitPrice;

        if (taxPercentageSumMap.containsKey(taxPercentage)) {
          taxPercentageSumMap[taxPercentage] =
              taxPercentageSumMap[taxPercentage]! + unitPrice;
        } else {
          taxPercentageSumMap[taxPercentage] = unitPrice;
        }
      }

// Construindo a string com os valores agrupados
      String IVA = '';
      taxPercentageSumMap.forEach((taxPercentage, sum) {
        IVA +=
        '$taxPercentage%      ${sum.toStringAsFixed(2)}EUR       ${(sum *
            taxPercentage / 100).toStringAsFixed(2)}EUR\n';
      });

      // Convertendo o texto para UTF-8
      List<int> IVAUtf8Bytes = utf8.encode(IVA);

      // Enviar comandos para a impressora
      socket.add(tituloCentrado);
      socket.write(cabecalho);
      socket.add(faturaN);
      socket.write(separador);
      socket.add(indiceUtf8Bytes);
      socket.add(pordutosUtf8Bytes);
      socket.add(totalImpE);
      socket.add(totalCentrado);
      socket.write(separador);
      socket.add(indiceImpUtf8Bytes);
      socket.add(IVAUtf8Bytes);

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
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dividir Conta'),
          backgroundColor: const Color(0xff00afe9),
          actions: [
            IconButton(
              icon: const Icon(Icons.person_add_outlined),
              tooltip: 'Open client',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AdicionarClientePage(
                        pedido: widget.pedido,
                        pedidos: database.getAllPedidos(),
                        artigos: database.getAllArtigos())
                ));
              },
            ),
          ],
          leading: Visibility(
            visible: botaoPressionado.every((element) =>
            element.pressionado == false),
            child: IconButton(
              icon: const Icon(Icons.arrow_back), // Ícone padrão de voltar
              onPressed: () {
                // Navegar para a página anterior
                Navigator.pop(context, false);
              },
            ),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove), onPressed: diminuirPessoas,),
                Text('$numPessoas Clientes',
                  style: const TextStyle(fontSize: 20),),
                IconButton(
                  icon: const Icon(Icons.add), onPressed: aumentarPessoas,),
              ],
            ),
            const SizedBox(height: 20),
            Text('Total do Pedido: ${widget.pedido.total.toStringAsFixed(2)} €',
              style: const TextStyle(fontSize: 20),),
            const SizedBox(height: 20),
            Text('Total Recebido: ${valoresIndividuais.reduce((value,
                element) => value + element).toStringAsFixed(2)} €',
              style: const TextStyle(fontSize: 20),),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: numPessoas,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Row(
                      children: [
                        Text(
                          'Cliente ${index + 1}: € ',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Expanded(
                          child: TextFormField(
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            controller: controllers[index],
                            onTap: () {
                              // Limpe o campo quando ganhar foco
                              controllers[index].clear();
                            },
                            onEditingComplete: () {
                              // Atualize a lista de valores quando a edição for concluída
                              final text = controllers[index].text;
                              if (text.isNotEmpty) {
                                valoresIndividuais[index] = double.parse(text);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (botaoPressionado[index]
                            .pressionado) // Mostrar apenas quando o botão estiver cobrado
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                botaoPressionado[index].pressionado = false;
                                mostrarBotaoConcluir = false;
                                botaoPressionado[index].metodo.valor -=
                                valoresIndividuais[index];
                                database.addMetodoPagamento(
                                    botaoPressionado[index].metodo);
                                widget.turno.setMetudo = 0;
                                database.addTurno(widget.turno);
                              });
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                            label: const Text(
                              'Anular',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ElevatedButton(
                          onPressed: botaoPressionado[index].pressionado
                              ? null
                              : () => cobrarValor(index),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: botaoPressionado[index].pressionado
                                ? Colors.grey
                                : const Color(0xff00afe9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: Colors.black),
                            ),
                          ),
                          child: Text(botaoPressionado[index].pressionado
                              ? 'Cobrado'
                              : 'Cobrar'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            if (mostrarBotaoConcluir)
              Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 30,),
                      Checkbox(
                        value: widget.setup.email,
                        onChanged: (value) {
                          setState(() {
                            widget.setup.email = value!;
                            _showEmailField = value;
                          });
                        },
                      ),
                      Text('Enviar por email'),
                    ],
                  ),
                  if (_showEmailField)
                    Padding(padding: const EdgeInsets.only(left: 25, right: 25),
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'Digite seu email',
                        ),
                      ),
                    ),
                  const SizedBox(height: 5),
                  if (widget.impressoras.isNotEmpty)
                    Row(
                      children: [
                        const SizedBox(width: 30,),
                        Checkbox(
                          value: widget.setup.imprimir,
                          onChanged: (value) {
                            setState(() {
                              widget.setup.imprimir = value!;
                            });
                          },
                        ),
                        Text('Imprimir documento'),
                      ],
                    ),
                  const SizedBox(height: 10),
                  SizedBox(
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: concluirVenda,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff00afe9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: const BorderSide(color: Colors.black),
                          ),
                        ),
                        child: const Text(
                          'CONCLUIR VENDA',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      )),
                  const SizedBox(height: 20),
                ],
              )
          ],
        ),
      ),
    );
  }
}

class MetudobotaoPressionado {
  bool pressionado;
  MetodoPagamentoObj metodo;

  MetudobotaoPressionado(this.pressionado, this.metodo);
}
