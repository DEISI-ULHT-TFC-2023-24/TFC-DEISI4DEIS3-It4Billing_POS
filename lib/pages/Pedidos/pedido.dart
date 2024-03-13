import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:it4billing_pos/pages/Pedidos/carrinho.dart';
import '../../main.dart';
import '../../objetos/artigoObj.dart';
import '../../objetos/categoriaObj.dart';
import '../../objetos/pedidoObj.dart';

class PedidoPage extends StatefulWidget {
  List<PedidoObj> pedidos = [];
  List<Categoria> categorias = [];
  List<Artigo> artigos = database.getAllArtigos();

  PedidoPage({
    Key? key,
    required this.pedidos,
    required this.categorias,
  }) : super(key: key);

  @override
  _PedidoPage createState() => _PedidoPage();
}

class _PedidoPage extends State<PedidoPage> with TickerProviderStateMixin {
  Categoria categoriaSelecionada = Categoria(
    nome: 'Todos os artigos',
    description: '',
    nomeCurto: '',
  );

  late TextEditingController searchController;
  bool showSearch = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    pedido.nrArtigos =
        pedido.artigosPedidoIds.length; //atualiza o contador do carrinho

    searchController = TextEditingController();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
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
              database.getCategorias(artigo.idArticlesCategories)?.nome ==
                  categoriaSelecionada.nome &&
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

      print("Código de barras lido: $barcode");
    } catch (e) {
      // Lidar com erros ao ler o código de barras
      print("Erro ao ler o código de barras: $e");
    }
  }

  // aqui é criado o objeto venda para enviar para o carrinho
  // mudar o nome do pedido para que seja incrementado por exemplo
  PedidoObj pedido = PedidoObj(
      nome: "Pedido 01",
      hora: DateTime.now(),
      funcionarioID: 0,
      total: 0,
      localId: -1,
      clienteID: 0);

  // estudar a parte de voltar a entrar dentro do pedido
  // como vou carregar toda a info ??devo adicionar mais variaveis ao pedido por exemplo
  // o numero de artigos dentro do carrinho para que eu possa logo carregar esse valor

  void addItemToCart() {
    setState(() {
      pedido.nrArtigos++;
      _controller.forward(from: 0.0).then((_) {
        _controller.reverse();
      });
    });
  }

  Future<void> addUserAoPedido() async {
    /// isto vai ser alterrado porque tenho de ter o utilizador da seção
    pedido.funcionarioID = database.getAllUtilizadores()[0].id;
    print('estive aqui e entao o pedido tem utilizador ${pedido.funcionarioID}');

    ///este zer0 tera de ser mudado ele escolhe qual é o utilizador
  }

  @override
  Widget build(BuildContext context) {
    pedido.nome = "Pedido ${widget.pedidos.length + 1}";

    return Scaffold(
      appBar: AppBar(
        title: Text(pedido.nome),
        backgroundColor: const Color(0xff00afe9),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: ScaleTransition(
                  scale: Tween<double>(begin: 1, end: 1.5).animate(
                    CurvedAnimation(
                      parent: _controller,
                      curve: Curves.easeInOut,
                    ),
                  ),
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
                onPressed: () async {
                  pedido.total = 0;
                  await addUserAoPedido();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CarrinhoPage(
                                artigos: widget.artigos,
                                categorias: widget.categorias,
                                pedidos: widget.pedidos,
                                pedido: pedido,
                              )));
                },
              ),
              Positioned(
                right: 6,
                top: 6,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CarrinhoPage(
                                  artigos: widget.artigos,
                                  categorias: widget.categorias,
                                  pedidos: widget.pedidos,
                                  pedido: pedido,
                                )));
                  },
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 1, end: 1.5).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: Curves.easeInOut,
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${pedido.nrArtigos}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              // Aqui você pode adicionar a lógica para lidar com as opções selecionadas
              print('Opção selecionada: ${pedido.nome}');
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
                              pedido.artigosPedidoIds
                                  .add(artigosFiltrados()[index].id);
                              print('foi adicionado o artigo');
                              addItemToCart();
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
                                Text(
                                  artigosFiltrados()[index].nome.length > 20
                                      ? artigosFiltrados()[index]
                                          .nome
                                          .substring(0, 20)
                                      : artigosFiltrados()[index].nome,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                                Text(
                                  'Preço: € ${artigosFiltrados()[index].price}',
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
