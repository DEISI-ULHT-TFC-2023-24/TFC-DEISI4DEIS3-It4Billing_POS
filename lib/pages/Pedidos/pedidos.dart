import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:it4billing_pos/pages/Pedidos/pedido.dart';
import '../../navbar.dart';
import 'package:it4billing_pos/objetos/vendaObj.dart';
import 'package:it4billing_pos/objetos/artigoObj.dart';
import 'package:it4billing_pos/objetos/categoriaObj.dart';

class Pedidos extends StatefulWidget {
  late List<VendaObj> vendas = [];

  Pedidos({
    Key? key,
    required this.vendas,
  }) : super(key: key);

  @override
  State<Pedidos> createState() => _Pedidos();
}

class _Pedidos extends State<Pedidos> {

  // contruir ainda a forma como tratar a info da base de dab«dos e perceber como vou receber
  // ainda a data para a base de dados

  List<Categoria> categorias = [
    Categoria(nome: 'Todos os artigos', description: '', nomeCurto: ''),
    Categoria(nome: "Categoria 1", nomeCurto: "Cat 1", description: ''),
    Categoria(nome: "Categoria 2", nomeCurto: "Cat 2", description: ''),
    Categoria(nome: "Categoria 3", nomeCurto: "Cat 3", description: ''),
  ];
  List<Artigo> artigos = [];

  getcat() {
    artigos = [
      Artigo(
        referencia: "001",
        nome: "Artigo 1",
        barCod: '',
        description: '',
        productType: '',
        unitPrice: 4.06,
        idArticlesCategories: 1,
        categoria: categorias[1],
        taxPrecentage: 23,
        idTaxes: 1,
        taxName: '',
        taxDescription: '',
        idRetention: 1,
        retentionPercentage: 1,
        retentionName: '',
        stock: 56
      ),
      Artigo(
        referencia: "002",
        nome: "Artigo 2",
        barCod: '',
        description: '',
        productType: '',
        unitPrice: 6.42,
        idArticlesCategories: 2,
        categoria: categorias[2],
        taxPrecentage: 23,
        idTaxes: 2,
        taxName: '',
        taxDescription: '',
        idRetention: 2,
        retentionPercentage: 2,
        retentionName: '',
        stock: 10
      ),
    ];
  }

  // criar lista com cat teste para enviar para a proxima pagina e ai fazer os objetos consuante o numero de coisas
  // fazer tbm o ecra sub cat (no mesmo ecra )
  // tendo a lista do objetos tbm criada aqui  fazer a cena de selecionar e ai ter o botao que faz add na lista de vendas

  @override
  Widget build(BuildContext context) => WillPopScope(
      child: Scaffold(
        drawer: const NavBar(),
        appBar: AppBar(
          title: const Text('Pedidos'),
          backgroundColor: const Color(0xff00afe9),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 20 + MediaQuery.of(context).padding.top,
                bottom: 20,
              ),
              child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  child: ElevatedButton(
                    onPressed: () {
                      getcat();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Pedido(
                                    artigos: artigos,
                                    categorias: categorias,
                                    vendas: widget.vendas,
                                  )));
                      // Adiciona um novo objeto à lista quando o botão é pressionado
                      setState(() {

                      });
                    },
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                          const BorderSide(color: Colors.black)),
                      // Linha de borda preta
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      // Fundo transparente
                      fixedSize:
                          MaterialStateProperty.all(const Size(8000, 80)),
                      // Tamanho fixo de 270x80
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    child: const Text(
                      'NOVO PEDIDO',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  )),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.vendas.length,
                itemBuilder: (context, index) {
                  return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 50),
                      child: ElevatedButton(
                          onPressed: () {
                            // entrar dentro do pedido ainda aberto ex.vendas[index].nome
                          },
                          style: ButtonStyle(
                            side: MaterialStateProperty.all(
                                const BorderSide(color: Colors.black)),
                            // Linha de borda preta
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            // Fundo white
                            fixedSize:
                                MaterialStateProperty.all(const Size(300, 80)),
                            // Tamanho fixo de 270x80
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(widget.vendas[index].local,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 18)
                                  ),
                                  Text(DateFormat('HH:mm').format(widget.vendas[index].hora),
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 18)
                                  ),
                                ],
                              ),
                              Text('Funcionario: ${widget.vendas[index].funcionario.nome}',
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 18)
                              ),
                            ],
                          ),


                      )
                  );
                },
              ),
            ),
          ],
        ),
      ),
      onWillPop: () async {
        final shouldPop = await showMyDialog(context);
        return shouldPop ?? false;
      });

  Future<bool?> showMyDialog(BuildContext context) => showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Quer sair da aplicação?"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('CANCELAR')),
              TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('SIM'))
            ],
          ));
}
