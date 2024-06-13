import 'dart:convert';
import 'dart:io';

import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
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
  int numPessoas = 2;
  List<double> valoresIndividuais = [];
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
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void calcularValoresIndividuais() {
    double totalPedido = widget.pedido.total;
    setState(() {
      valoresIndividuais.clear();
      double valorIndividual = double.parse((totalPedido / numPessoas).toStringAsFixed(2));
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
            valor.toStringAsFixed(2)));
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
      mostrarBotaoConcluir = false; // Se aumentar o número de pessoas, o botão "Concluir Venda" deve desaparecer
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
    VendaObj venda = VendaObj(
        nome: widget.pedido.nome,
        hora: widget.pedido.hora,
        funcionarioID: widget.pedido.funcionarioID,
        localId: widget.pedido.localId,
        total: widget.pedido.total);
    venda.artigosPedidoIds = widget.pedido.artigosPedidoIds;
    venda.nrArtigos = widget.pedido.nrArtigos;

    //Lógica para enviar por email e/ou imprimir com base nas escolhas do utilizador
    if (widget.setup.email && _showEmailField) {
      // Enviar por email para _emailController.text
    }
    if (widget.setup.imprimir && database.getAllImpressoras().isNotEmpty) {
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
    final String cidadeEstadoCodigoPostalEmpresa = "1234-678 - Cidade da Emprresa";
    final String telefoneEmpresa = "219876543";
    final String nifEmpresa = '502123456';


    final templates = database.getAllTemplates();
    String templateContent = templates.isNotEmpty ? templates[0].content : '';

    Map<String, dynamic> variaveis = {
      'nomeEmpresa': nomeEmpresa,
      'moradaEmpresa': moradaEmpresa,
      'cidadeEstadoCodigoPostalEmpresa': cidadeEstadoCodigoPostalEmpresa,
      'telefoneEmpresa': telefoneEmpresa,
      'nifEmpresa': nifEmpresa,

      'nomeCliente': database.getCliente(widget.pedido.clienteID)!.nome,
      'morada': database.getCliente(widget.pedido.clienteID)!.address,
      'codPostal': database.getCliente(widget.pedido.clienteID)!.postcode,
      'nifCliente': database.getCliente(widget.pedido.clienteID)!.NIF,
      'tel': database.getCliente(widget.pedido.clienteID)!.phone,

      'dataEmissao': DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
      'vendador': database.getFuncionario(widget.setup.funcionarioId)!.nome,
      'fatura': 'FT XPTO/158',

      'total': widget.pedido.calcularValorTotal().toStringAsFixed(2),
      'ATCUD': 'JDFTW25-96552'
    };

    // Função para substituir todas as ocorrências das variáveis no texto
    String substituirVariaveis(String texto, Map<String, dynamic> variaveis) {
      variaveis.forEach((chave, valor) {
        texto = texto.replaceAll('\${$chave}', valor.toString());
      });
      return texto;
    }
    templateContent = substituirVariaveis(templateContent, variaveis);

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
          '$valor     ${artigoLista.taxPrecentage}%      ${artigoLista.price.toStringAsFixed(2)}EUR     ${artigoLista.discount.toStringAsFixed(2)}EUR    ${(artigoLista.price * valor).toStringAsFixed(2)}EUR\n'
              '$nomeArtigo\n';
          break;
        }
      }
    });

    Map<int, double> taxPercentageSumMap = {};
// Agrupando os artigos com base no valor de taxPercentage e calculando a soma de unitPrice para cada grupo
    artigosAgrupados.forEach((chave, valor) {
      // Verifica se o artigo está presente na lista
      for (Artigo artigoLista in widget.pedido.artigosPedido) {
        if (artigoLista.nome == database.getArtigo(chave)!.nome) {
          int taxPercentage = artigoLista.taxPrecentage;
          double unitPrice = artigoLista.unitPrice;

          if (taxPercentageSumMap.containsKey(taxPercentage)) {
            taxPercentageSumMap[taxPercentage] = taxPercentageSumMap[taxPercentage]! + (unitPrice * valor);
          } else {
            taxPercentageSumMap[taxPercentage] = unitPrice * valor;
          }
        }
      }
    });

// Constroi a string com os valores agrupados
    String IVA = '';
    taxPercentageSumMap.forEach((taxPercentage, sum) {
      IVA += '$taxPercentage%      ${sum.toStringAsFixed(2)}EUR       ${(sum * taxPercentage / 100).toStringAsFixed(2)}EUR\n';
    });

    // Conectar com a impressora
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);

    final PosPrintResult res = await printer.connect(impressora.iP, port: impressora.port);
    List<String> template = templateContent.split(';');

    if (res == PosPrintResult.success) {
      printer.text(template[0], styles: const PosStyles(align: PosAlign.center, bold: true));
      printer.text(template[1], styles: const PosStyles(align: PosAlign.left));
      printer.text(pordutos, styles: const PosStyles(align: PosAlign.left));
      printer.text(template[2], styles: const PosStyles(align: PosAlign.left));
      printer.text(template[3], styles: const PosStyles(align: PosAlign.center,height: PosTextSize.size2, width: PosTextSize.size2));
      printer.text(template[4], styles: const PosStyles(align: PosAlign.left));
      printer.text(IVA, styles: const PosStyles(align: PosAlign.left));
      printer.text(template[5], styles: const PosStyles(align: PosAlign.left));


      printer.qrcode('A:$nifEmpresa*B:${database.getCliente(widget.pedido.clienteID)!.NIF}'
          '*C:PT*D:FR*E:N*F:20240408*G:FR U003/87441*H:JDFTW25-96552*I1:PT*I3:10.19*I4:0.61*N:0.61*O:${widget.pedido.calcularValorTotal().toStringAsFixed(2)}*Q:GgPN*R:432', size: QRSize.Size8);
      printer.feed(2);
      printer.cut();
      printer.disconnect();
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
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
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
                              // Limpa o campo quando ganhar foco
                              controllers[index].clear();
                            },
                            onEditingComplete: () {
                              // Atualiza a lista de valores quando a edição for concluída
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
                            .pressionado)
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
                        const Text('Imprimir documento'),
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
