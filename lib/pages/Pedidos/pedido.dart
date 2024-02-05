import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../../objetos/artigoObj.dart';
import '../../objetos/categoriaObj.dart';
import '../../objetos/vendaObj.dart';

class Pedido extends StatefulWidget {
  List<VendaObj> vendas = [];
  List<Categoria> categorias = [];
  List<Artigo> artigos = [];

  Pedido({
    Key? key,
    required this.vendas,
    required this.categorias,
    required this.artigos,
  }) : super(key: key);

  @override
  _Pedido createState() => _Pedido();
}

class _Pedido extends State<Pedido> {
  Categoria categoriaSelecionada = Categoria(
    nome: 'Todos os artigos',
    description: '',
    nomeCurto: '',
  );

  late TextEditingController searchController;
  bool showSearch = false;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  List<Artigo> artigosFiltrados() {
    if (categoriaSelecionada.nome == 'Todos os artigos') {
      return widget.artigos
          .where((artigo) => artigo.nome
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    } else {
      return widget.artigos
          .where((artigo) =>
              artigo.categoria.nome == categoriaSelecionada.nome &&
              artigo.nome
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase()))
          .toList();
    }
  }

  Future<void> _scanBarcode() async {
    try {
      String barcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancelar',
        true,
        ScanMode.BARCODE,
      );

      // Aqui você pode lidar com o código de barras lido (por exemplo, pesquisar na lista de artigos)
      print("Código de barras lido: $barcode");
    } catch (e) {
      // Lidar com erros ao escanear o código de barras
      print("Erro ao escanear o código de barras: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedido 01'), // Mudar
        backgroundColor: const Color(0xff00afe9),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            tooltip: 'Open shopping cart',
            onPressed: () {
              // handle the press
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            tooltip: 'Open shopping cart',
            onPressed: () {
              // handle the press
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: showSearch
                    ? Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextField(
                          controller: searchController,
                          decoration: const InputDecoration(
                            hintText: 'Pesquisar artigos...',
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(20),
                        child: DropdownButtonFormField<Categoria>(
                          decoration: const InputDecoration(
                            label: Text('Categoria'),
                            border: OutlineInputBorder(),
                          ),
                          value: categoriaSelecionada,
                          onChanged: (Categoria? newValue) {
                            setState(() {
                              categoriaSelecionada = newValue!;
                            });
                          },
                          items: widget.categorias
                              .map<DropdownMenuItem<Categoria>>(
                                  (Categoria value) {
                            return DropdownMenuItem<Categoria>(
                              value: value,
                              child: Text(value.nome),
                            );
                          }).toList(),
                        ),
                      ),
              ),
              IconButton(
                icon: showSearch
                    ? const Icon(Icons.close)
                    : const Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    // Faz com que apareca todos os artigos novamente
                    categoriaSelecionada = Categoria(
                      nome: 'Todos os artigos',
                      description: '',
                      nomeCurto: '',
                    );
                    showSearch = !showSearch;
                    if (!showSearch) {
                      searchController.clear();
                    }
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.camera_alt_outlined),
                onPressed: _scanBarcode,
              ),
            ],
          ),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: artigosFiltrados().isEmpty
                    ? const Center(
                        child: Text('Nenhum artigo encontrado'),
                      )
                    : ListView.builder(
                        itemCount: artigosFiltrados().length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: ElevatedButton(
                              onPressed: () {
                                // Adicione a lógica desejada ao pressionar o botão do artigo
                                print(
                                    'Botão Pressionado: ${artigosFiltrados()[index].nome}'
                                    '-'
                                    '${artigosFiltrados()[index].unitPrice}'
                                    ' '
                                    '${artigosFiltrados()[index].taxPrecentage / 100 + 1}');
                              },
                              style: ButtonStyle(
                                side: MaterialStateProperty.all(
                                    const BorderSide(color: Colors.white12)),
                                // Linha de borda preta
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                // Fundo white
                                fixedSize: MaterialStateProperty.all(
                                    const Size(50, 60)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(artigosFiltrados()[index].nome,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 16)),
                                  Text(
                                      'Preço: € ${(artigosFiltrados()[index].unitPrice * (artigosFiltrados()[index].taxPrecentage / 100 + 1)).toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 16)),
                                ],
                              ),
                            ),
                          );
                        },
                      )),
          ),
        ],
      ),
    );
  }
}
