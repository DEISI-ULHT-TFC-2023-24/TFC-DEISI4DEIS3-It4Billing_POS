import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:it4billing_pos/main.dart';
import 'package:it4billing_pos/objetos/VendaObj.dart';
import 'package:it4billing_pos/Paginas/Pedidos/pedidos.dart';

import '../../objetos/artigoObj.dart';
import '../../objetos/impressoraObj.dart';
import '../../objetos/pedidoObj.dart';
import '../../objetos/setupObj.dart';
import '../Cliente/addClientePage.dart';

class ConcluirPedido extends StatefulWidget {
  late PedidoObj pedido;
  late String troco;
  SetupObj setup = database.getAllSetup()[0];
  List<ImpressoraObj> impressoras = database.getAllImpressoras();

  ConcluirPedido({
    Key? key,
    required this.pedido,
    required this.troco,
  }) : super(key: key);

  @override
  _ConcluirPedidoState createState() => _ConcluirPedidoState();
}

class _ConcluirPedidoState extends State<ConcluirPedido> {
  late TextEditingController _emailController;
  bool _showEmailField = false;

  late Map<int, int> artigosAgrupados;

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
    if (widget.pedido.clienteID != database.getAllClientes()[0].id) {
      if (database.getCliente(widget.pedido.clienteID)?.email != 'N/D') {
        _emailController = TextEditingController(
            text: database.getCliente(widget.pedido.clienteID)?.email);
      } else {
        _emailController = TextEditingController();
      }
    }
    artigosAgrupados = groupItems(widget.pedido.artigosPedidoIds);
    super.initState();
  }

  @override
  void dispose() {
    if (widget.pedido.clienteID != 0 &&
        widget.pedido.clienteID != database.getAllClientes()[0].id) {
      _emailController.dispose();
    }
    super.dispose();
  }

  void concluirVenda() {
    VendaObj venda = VendaObj(
      nome: widget.pedido.nome,
      hora: widget.pedido.hora,
      funcionarioID: widget.pedido.funcionarioID,
      localId: widget.pedido.localId,
      total: widget.pedido.total,
    );
    venda.artigosPedidoIds = widget.pedido.artigosPedidoIds;
    venda.nrArtigos = widget.pedido.nrArtigos;

    database.addVenda(venda);
    if (widget.pedido.id != 0) {
      if (database.getPedido(widget.pedido.id) != null) {
        database.removePedido(widget.pedido.id);
      }
    }
    // IMPRIMIR
    if (widget.setup.imprimir && widget.impressoras.isNotEmpty) {
      imprimir();
    }
    ;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => PedidosPage(),
      ),
      (route) => false, // Remove todas as rotas anteriores
    );
    print('Venda concluída!');
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
          'Cód. Postal: ${database.getCliente(widget.pedido.clienteID)!.postcode}\n';
      cabecalho +=
          'NIF: ${database.getCliente(widget.pedido.clienteID)!.NIF}\n';
      cabecalho +=
          'Tel: ${database.getCliente(widget.pedido.clienteID)!.phone}\n\n';
      cabecalho +=
          'Data de Emissao: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}\n';
      cabecalho +=
          'Vendador: ${database.getFuncionario(widget.setup.funcionarioId)!.nome}\n';

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

      final indice =    'Qtd.---IVA%-----Preco-------Desc.-------Total\n';
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
            pordutos += '$valor     ${artigoLista.taxPrecentage}%      ${artigoLista.price.toStringAsFixed(2)}EUR     ${artigoLista.discount.toStringAsFixed(2)}EUR    ${(artigoLista.price * valor).toStringAsFixed(2)}EUR\n'
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
      String total = 'Total EURO ${widget.pedido.calcularValorTotal().toStringAsFixed(2)}\n\n';

      final totalCentrado = [
        ...ativarNegrito,
        ...aumentarFonte,
        ...utf8.encode(total),
        ...tamanhoFonte,
        ...alinhamentoPadrao,
        ...desativarNegrito
      ];


      final indiceImp ='Detalhes do IVA\n\n'
                       'Taxa  x  Incidencia   = Total Impos.\n';
      List<int> indiceImpUtf8Bytes = utf8.encode(indiceImp);

      Map<int, double> taxPercentageSumMap = {};

// Agrupando os artigos com base no valor de taxPrecentage e calculando a soma de unitPrice para cada grupo
      for (Artigo artigoLista in widget.pedido.artigosPedido) {
        int taxPercentage = artigoLista.taxPrecentage;
        double unitPrice = artigoLista.unitPrice;

        if (taxPercentageSumMap.containsKey(taxPercentage)) {
          taxPercentageSumMap[taxPercentage] = taxPercentageSumMap[taxPercentage]! + unitPrice;
        } else {
          taxPercentageSumMap[taxPercentage] = unitPrice;
        }
      }

// Construindo a string com os valores agrupados
      String IVA = '';
      taxPercentageSumMap.forEach((taxPercentage, sum) {
        IVA += '$taxPercentage%      ${sum.toStringAsFixed(2)}EUR       ${(sum * taxPercentage /100).toStringAsFixed(2)}EUR\n';
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
    return WillPopScope(
      onWillPop: () async {
        // Impede que o utilizador volte usando o botão de voltar do dispositivo
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.pedido.nome),
          backgroundColor: const Color(0xff00afe9),
          automaticallyImplyLeading: false, // Remove o ícone de voltar
          actions: [
            IconButton(
              icon: const Icon(Icons.person_add_outlined),
              tooltip: 'Open client',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AdicionarClientePage(
                        pedido: widget.pedido,
                        pedidos: database.getAllPedidos(),
                        artigos: database.getAllArtigos())));
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 45, right: 45),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total pago',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${widget.pedido.calcularValorTotal().toStringAsFixed(2)} €',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Troco',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${widget.troco} €',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      //verifica se tem algum clente ou se é o cliente predefenido
                      if (widget.pedido.clienteID != 0 &&
                          widget.pedido.clienteID !=
                              database.getAllClientes()[0].id)
                        Row(
                          children: [
                            Checkbox(
                              value: widget.setup.email,
                              onChanged: (value) {
                                setState(() {
                                  widget.setup.email = value!;
                                  _showEmailField = value;
                                });
                              },
                            ),
                            const Text('Enviar por email'),
                          ],
                        ),
                      if (_showEmailField)
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            hintText: 'Digite seu email',
                          ),
                        ),
                      const SizedBox(height: 5),
                      if (widget.impressoras.isNotEmpty)
                        Row(
                          children: [
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
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 30, left: 80, right: 80),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: concluirVenda,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff00afe9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.black),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  'CONCLUIR VENDA',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
