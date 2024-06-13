import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:it4billing_pos/Paginas/Vendas/venda.dart';
import 'package:it4billing_pos/Paginas/artigos.dart';
import 'package:it4billing_pos/Paginas/Turnos/turno.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../main.dart';
import '../../objetos/VendaObj.dart';
import '../../objetos/artigoObj.dart';
import '../../objetos/setupObj.dart';
import '../../objetos/turnoObj.dart';
import '../Pedidos/pedidos.dart';
import '../Turnos/turnoFechado.dart';
import '../categorias.dart';
import '../Configuracoes/configuracoes.dart';

class VendasPage extends StatefulWidget {
  VendasPage({Key? key}) : super(key: key);

  @override
  _VendasPage createState() => _VendasPage();
}

class _VendasPage extends State<VendasPage> {
  List<VendaObj> vendas = database.getAllVendas()
    ..sort((a, b) => b.hora.compareTo(a.hora));
  TurnoObj turno = database.getAllTurno()[0];
  SetupObj setup = database.getAllSetup()[0];

  bool isTablet = false;
  late Map<int, int> artigosAgrupados;
  bool emitirNotaCredito = false;

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
    if (vendas.isNotEmpty) {
      artigosAgrupados = groupItems(vendas[selectedIndex].artigosPedidoIds);
    }
  }

  void atulizarArtigosCarrinho() {
    setState(() {
      if (vendas.isNotEmpty) {
        artigosAgrupados = groupItems(vendas[selectedIndex].artigosPedidoIds);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    checkDeviceType();
  }

  void checkDeviceType() {
    final screenSize = MediaQuery.of(context).size;
    setState(() {
      isTablet = screenSize.width > 600 && screenSize.height > 600;
    });
  }

  Widget buildHeader(BuildContext context) => Container(
        color: const Color(0xff00afe9),
        padding: EdgeInsets.only(
          top: 50 + MediaQuery.of(context).padding.top,
          left: 20,
          bottom: 50,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              database.getFuncionario(turno.funcionarioID)!.nome,
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
            Text(
              setup.nomeLoja,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            Text(
              setup.pos,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      );

  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        child: Wrap(
          runSpacing: 5,
          children: [
            ListTile(
              leading: const Icon(Icons.shopping_cart_outlined),
              title: const Text('Pedidos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => PedidosPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text('Vendas concluidas'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time_outlined),
              title: const Text('Turno'),
              onTap: () {
                Navigator.pop(context);
                if (turno.turnoAberto) {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TurnosPage()));
                } else {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TurnoFechado()));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_outlined),
              title: const Text('Artigos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ArtigosPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.label_outline),
              title: const Text('Categorias'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CategoriasPage()));
              },
            ),
            const Divider(color: Colors.black54),
            ListTile(
              leading: const Icon(Icons.bar_chart_outlined),
              title: const Text('Back office'),
              onTap: () {
                Navigator.pop(context);
                _launchURL('https://app.it4billing.com/Login');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configurações'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ConfiguracoesPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Suporte'),
              onTap: () {
                Navigator.pop(context);
                _launchURL('https://www.it4billing.com/suporte/');
              },
            ),
          ],
        ),
      );

  _launchURL(String url) async {
    try {
      final uri = Uri.parse(url);
      await launchUrl(uri);
    } catch (e) {
      print('Erro ao lançar a URL: $e');
    }
  }

  // Variável para reiniciar o índice do item selecionado
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Vendas concluídas'),
        backgroundColor: const Color(0xff00afe9),
      ),
      //isTablet ? TabletLayout() : PhoneLayout(),
      body: isTablet
          ? vendas.isEmpty
              ? const Center(
                  child: Text(
                    'Não existem vendas concluídas',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : Row(
                  children: [
                    // Lista de definições
                    Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: vendas.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // entrar dentro da venda
                                          setState(() {
                                            selectedIndex = index;
                                            atulizarArtigosCarrinho();
                                          });
                                        },
                                        style: ButtonStyle(
                                          side: MaterialStateProperty.all(
                                              const BorderSide(
                                                  color: Colors.black)),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.white),
                                          fixedSize: MaterialStateProperty.all(
                                              const Size(300, 80)),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(DateFormat(
                                                            'dd/MM/yyyy HH:mm')
                                                        .format(
                                                            vendas[index].hora),
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    'Total: ${vendas[index].total.toStringAsFixed(2)} €',
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 5),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                    'FT XPTO/158',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  if (vendas[index].anulada)
                                                    const Text(
                                                      'ANULADO',
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ));
                                },
                              ),
                            ),
                          ],
                        )),
                    // Conteúdo da definição selecionada
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Expanded(
                            child: ListView.builder(
                              itemCount: artigosAgrupados.length,
                              itemBuilder: (context, index) {
                                int artigoId =
                                    artigosAgrupados.keys.elementAt(index);
                                int quantidade = artigosAgrupados[artigoId]!;
                                double valor =
                                    database.getArtigo(artigoId)!.price;
                                Artigo artigo = database.getArtigo(artigoId)!;

                                /// isto vai dar problemas no editar carrinho
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, bottom: 10.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                    },
                                    style: ButtonStyle(
                                      side: MaterialStateProperty.all(
                                          const BorderSide(
                                              color: Colors.white12)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                      fixedSize: MaterialStateProperty.all(
                                          const Size(50, 60)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                                artigo.nome.length > 10
                                                    ? artigo.nome
                                                        .substring(0, 20)
                                                    : artigo.nome,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16)),
                                            const SizedBox(width: 10),
                                            Text('x $quantidade',
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16)),
                                          ],
                                        ),
                                        Text(
                                            '${(valor * quantidade).toStringAsFixed(2)} €',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16)),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.only(left: 45, right: 45),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Text(
                                    '${vendas[selectedIndex].calcularValorTotal().toStringAsFixed(2)} €',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          vendas[selectedIndex].anulada
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      right: 20.0, bottom: 30),
                                  child: SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          side: const BorderSide(
                                              color: Colors.black),
                                        ),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Text(
                                          'ANULADO',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      right: 20.0, bottom: 30),
                                  child: SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        /// ter o pop
                                        _mostrarDialogo(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xffad171b),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          side: const BorderSide(
                                              color: Colors.black),
                                        ),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Text(
                                          'ANULAR',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                )
          : Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                vendas.isEmpty
                    ? const Expanded(
                        child: Center(
                        child: Text(
                          'Não existem vendas concluídas',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: vendas.length,
                          itemBuilder: (context, index) {
                            return Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // entrar dentro da venda
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => VendaPage(
                                                  vendas: vendas,
                                                  venda: vendas[index],
                                                )));
                                  },
                                  style: ButtonStyle(
                                    side: MaterialStateProperty.all(
                                        const BorderSide(color: Colors.black)),
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    fixedSize: MaterialStateProperty.all(
                                        const Size(300, 80)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              DateFormat('dd/MM/yyyy HH:mm')
                                                  .format(vendas[index].hora),
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              'Total: ${vendas[index].total.toStringAsFixed(2)} €',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'FT XPTO/158',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                              ),
                                            ),
                                            if (vendas[index].anulada)
                                              const Text(
                                                'ANULADO',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 18,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ));
                          },
                        ),
                      ),
              ],
            ),
    );
  }

  void _mostrarDialogo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Anular venda'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('Tem certeza que deseja anular?'),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: emitirNotaCredito,
                      onChanged: (bool? value) {
                        setState(() {
                          emitirNotaCredito = value ?? false;
                        });
                      },
                    ),
                    const Text('Emitir nota de credito'),
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.red),
                ),
                child: const Text('Não'),
              ),
              TextButton(
                onPressed: () {
                  vendas[selectedIndex].anulada = true;
                  database.addVenda(vendas[selectedIndex]);
                  // Atualizar o estado da propriedade notaCredito do objeto setup
                  setup.notaCredito = emitirNotaCredito;
                  // Salvar o objeto setup atualizado na BD
                  database.addSetup(setup);
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => VendasPage()));
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.green),
                ),
                child: const Text('Sim'),
              ),
            ],
          );
        });
      },
    );
  }
}
