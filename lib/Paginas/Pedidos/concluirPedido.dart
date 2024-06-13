import 'dart:convert';
import 'dart:io';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
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
  TextEditingController _emailController = TextEditingController();
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
    };

    database.getAllLocal().forEach((local) {
      if(local.id == widget.pedido.localId){
        local.ocupado = false;
        database.addLocal(local);
      }
    });

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => PedidosPage(),
      ),
      (route) => false,
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

    // Define um mapa com o valor de todas as variáveis
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
          //'valor' representa a quantidade do produto
          pordutos +=
          '$valor     ${artigoLista.taxPrecentage}%      ${artigoLista.price.toStringAsFixed(2)}EUR     ${artigoLista.discount.toStringAsFixed(2)}EUR    ${(artigoLista.price * valor).toStringAsFixed(2)}EUR\n'
              '$nomeArtigo\n';
          break;
        }
      }
    });

    Map<int, double> taxPercentageSumMap = {};
// Agrupar os artigos com base no valor de taxPercentage e calculando a soma de unitPrice para cada grupo
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
    return WillPopScope(
      onWillPop: () async {
        // Impede que o utilizador volte a utilizado o botão de voltar do dispositivo
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
                        artigos: database.getAllArtigos())
                )).then((value) {
                  if (value == true) {
                    setState(() {
                      _emailController.text = database.getCliente(widget.pedido.clienteID)!.email;
                    });
                  }
                });
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
                      //verifica se tem algum cliente ou se é o cliente predefenido
                      if (widget.pedido.clienteID != 0 && widget.pedido.clienteID != database.getAllClientes()[0].id)
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
