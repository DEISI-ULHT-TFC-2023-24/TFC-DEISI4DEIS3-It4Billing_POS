import 'package:flutter/material.dart';
import 'package:it4billing_pos/main.dart';
import 'package:it4billing_pos/objetos/VendaObj.dart';
import 'package:it4billing_pos/Paginas/Pedidos/pedidos.dart';
import 'package:it4billing_pos/Paginas/Vendas/vendas.dart';

import '../../objetos/artigoObj.dart';
import '../../objetos/categoriaObj.dart';
import '../../objetos/setupObj.dart';

class VendaPage extends StatefulWidget {
  late List<VendaObj> vendas = [];
  late VendaObj venda;
  SetupObj setup = database.getAllSetup()[0];

  VendaPage({
    Key? key,
    required this.vendas,
    required this.venda,
  }) : super(key: key);

  @override
  _VendaPageState createState() => _VendaPageState();
}

class _VendaPageState extends State<VendaPage> {
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
    artigosAgrupados = groupItems(widget.venda.artigosPedidoIds);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.venda.nome),
          backgroundColor: const Color(0xff00afe9),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                // Lógica para lidar com as opções selecionadas
                print('Opção selecionada: ${widget.venda.nome}');
                if (value == 'Eliminar pedido') {
                  database.removePedido(widget.venda.id);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => PedidosPage()));
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'Sincronizar',
                  child: ListTile(
                    leading: Icon(Icons.sync),
                    title: Text('Sincronizar'),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: artigosAgrupados.length,
                itemBuilder: (context, index) {
                  int artigoId = artigosAgrupados.keys.elementAt(index);
                  int quantidade = artigosAgrupados[artigoId]!;
                  double valor = database.getArtigo(artigoId)!.price;
                  Artigo artigo = database.getArtigo(artigoId)!;

                  /// isto vai dar problemas no editar carrinho
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        //entrar no artigo e quantidades e tal
                      },
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(
                            const BorderSide(color: Colors.white12)),
                        // Linha de borda preta
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        // Fundo white
                        fixedSize:
                            MaterialStateProperty.all(const Size(50, 60)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                  artigo.nome.length > 10
                                      ? artigo.nome.substring(0, 20)
                                      : artigo.nome,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16)),
                              const SizedBox(width: 10),
                              Text('x $quantidade',
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16)),
                            ],
                          ),
                          Text('${(valor * quantidade).toStringAsFixed(2)} €',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16)),
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
                      '${widget.venda.calcularValorTotal().toStringAsFixed(2)} €',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ),
            const SizedBox(height: 30),
            widget.venda.anulada
                ? Padding(
                    padding: const EdgeInsets.only(right: 20.0, bottom: 30),
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: null,
                        // Definir onPressed como null tornará o botão inativo
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          // Altere a cor de fundo para cinza
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Colors.black),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            'ANULADO',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(right: 20.0, bottom: 30),
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          /// ter o pop
                          _mostrarDialogo(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffad171b),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Colors.black),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            'ANULAR',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      );

  void _mostrarDialogo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Anular venda'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              // Para ajustar o tamanho do conteúdo
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
                  Navigator.of(context).pop(); // Fechar o diálogo
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.red), // Cor do texto
                ),
                child: const Text('Não'),
              ),
              TextButton(
                onPressed: () {
                  // Adicione aqui a lógica para anular
                  widget.venda.anulada = true;
                  database.addVenda(widget.venda);
                  // Atualizar o estado da propriedade notaCredito do objeto setup
                  widget.setup.notaCredito = emitirNotaCredito;
                  // Salvar o objeto setup atualizado na BD
                  database.addSetup(widget.setup);
                  Navigator.of(context).pop(); // Fechar o diálogo
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => VendasPage()));
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.green), // Cor do texto
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
