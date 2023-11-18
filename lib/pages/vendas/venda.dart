import 'package:flutter/material.dart';

import 'vendaObj.dart';
import 'artigo.dart';
import 'categoria.dart';

class Venda extends StatelessWidget {
  List<VendaObj> vendas = [];
  List<Categoria> categorias = [];
  List<Artigo> artigos = [];

  Venda({
    Key? key,
    required this.vendas,
    required this.categorias,
    required this.artigos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Venda 01'),
          backgroundColor: const Color(0xff00afe9),
        ),
        body: Container(
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: categorias.length,
                  itemBuilder: (context, index) {
                    return ElevatedButton(
                            onPressed: () {},
                            child: Text(categorias[index].nome)
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
}
