import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:it4billing_pos/pages/Pedidos/carrinho.dart';
import 'package:it4billing_pos/pages/Pedidos/pedidos.dart';
import '../../main.dart';
import '../../objetos/artigoObj.dart';
import '../../objetos/categoriaObj.dart';
import '../../objetos/localObj.dart';
import '../../objetos/pedidoObj.dart';

class PedidoAbertoPage extends StatefulWidget {
  List<PedidoObj> pedidos = [];
  List<Categoria> categorias = [];
  List<Artigo> artigos = [];
  List<LocalObj> locais = [];
  PedidoObj pedido;

  PedidoAbertoPage({
    Key? key,
    required this.pedido,
    required this.pedidos,
    required this.categorias,
    required this.artigos,
  }) : super(key: key);

  @override
  _PedidoAbertoPage createState() => _PedidoAbertoPage();
}

class _PedidoAbertoPage extends State<PedidoAbertoPage> with TickerProviderStateMixin {
  Categoria categoriaSelecionada = Categoria(
    nome: 'Todos os artigos',
    description: '',
    nomeCurto: '',
  );

  late TextEditingController searchController;
  bool showSearch = false;
  late AnimationController _controller;
  int nrArtigosInicial = 0;

  @override
  void initState() {
    super.initState();
    updateNrArtigos();

    nrArtigosInicial = widget.pedido.nrArtigos;

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
              database.getArtigo(artigo.idArticlesCategories)?.nome == categoriaSelecionada.nome &&
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

  // estudar a parte de voltar a entrar dentro do pedido
  // como vou carregar toda a info ??devo adicionar mais variaveis ao pedido por exemplo
  // o numero de artigos dentro do carrinho para que eu possa logo carregar esse valor

  void updateNrArtigos() {
    setState(() {
      widget.pedido.nrArtigos = widget.pedido.artigosPedidoIds.length;
    });
  }

  void addItemToCart() {
    setState(() {
      //widget.pedido.nrArtigos++;
      updateNrArtigos();
      _controller.forward(from: 0.0).then((_) {
        _controller.reverse();
      });
    });
  }

  void _removerObjeto(BuildContext context) {

    print(nrArtigosInicial);
    print('${widget.pedido.nrArtigos}');
    // Remover os últimos artigos da lista
    for (int i = nrArtigosInicial; i < widget.pedido.nrArtigos; i++) {
      print('removeu o ultimo obeto $i');
      widget.pedido.artigosPedidoIds.removeLast();

    }
    updateNrArtigos();
    // Navegar de volta à tela anterior
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // mudar o nome do pedido para que seja incrementado por exemplo

    return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              appBar: AppBar(
                title: Text(widget.pedido.nome),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    _removerObjeto(context);
                  },
                ),
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
                    onPressed: () {

                      for (int artigoId in widget.pedido.artigosPedidoIds) {
                        print('Nome: ${database.getArtigo(artigoId)?.nome} '
                            'Preço: ${database.getArtigo(artigoId)?.price}');
                      }
                      widget.pedido.total = 0;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CarrinhoPage(
                                    artigos: widget.artigos,
                                    categorias: widget.categorias,
                                    pedidos: widget.pedidos,
                                    pedido: widget.pedido,
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
                                      pedido: widget.pedido,
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
                            '${widget.pedido.nrArtigos}',
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
                  print('Opção selecionada: ${widget.pedido.nome}');
                  if (value == 'Eliminar pedido') {
                    database.removePedido(widget.pedido.id);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            PedidosPage()));
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'Eliminar pedido',
                    child: ListTile(
                      leading: Icon(Icons.delete_outline),
                      title: Text('Eliminar pedido'),
                    ),
                  ),
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
                                  widget.pedido.artigosPedidoIds
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
                                  fixedSize: MaterialStateProperty.all(
                                      const Size(50, 60)),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      artigosFiltrados()[index].nome.length > 10
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
        ));
  }
}
