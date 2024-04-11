import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:it4billing_pos/main.dart';
import 'package:it4billing_pos/objetos/clienteObj.dart';

import '../../objetos/artigoObj.dart';
import '../../objetos/pedidoObj.dart';
import 'editClientePage.dart';
import 'newClientePage.dart';

class AdicionarClientePage extends StatefulWidget {
  List<ClienteObj> clientes = database.getAllClientes();
  ClienteObj clienteSelecionado = database.getAllClientes()[0];
  late List<PedidoObj> pedidos = [];
  late List<Artigo> artigos = [];
  late PedidoObj pedido;

  AdicionarClientePage({
    Key? key,
    required this.pedido,
    required this.pedidos,
    required this.artigos,
  }) : super(key: key);

  @override
  _AdicionarClientePageState createState() => _AdicionarClientePageState();
}

class _AdicionarClientePageState extends State<AdicionarClientePage> {

  @override
  void initState() {
    super.initState();
    widget.clienteSelecionado = database.getCliente(widget.pedido.clienteID)!;
  }

  // Método para alterar o cliente selecionado
  void selecionarCliente(ClienteObj cliente) {
    setState(() {
      widget.clienteSelecionado = cliente;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Adicionar cliente ao pedido'),
        backgroundColor: const Color(0xff00afe9),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cliente selecionado',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      // Ação para editar o cliente
                      if (widget.clienteSelecionado.nome !=
                          'Consumidor Final') {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditarClientePage(
                                  cliente: widget.clienteSelecionado,
                                )));
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.clienteSelecionado.nome,
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Text(
                                '${widget.clienteSelecionado.NIF}',
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                          const Text(
                            'Editar',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            TextButton(
              onPressed: () {
                // Implementar ação para adicionar novo cliente
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => NovoClientePage()));
              },
              child: const Text(
                'Adicionar novo cliente',
                style: TextStyle(color: Colors.black),
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: widget.clientes.length,
                itemBuilder: (context, index) {
                  // Ignorar o primeiro elemento
                  if(index == 0) return SizedBox.shrink(); // ou qualquer outro widget vazio

                  ClienteObj cliente = widget.clientes[index];
                  return ListTile(
                    onTap: () {
                      selecionarCliente(cliente);
                    },
                    title: Text(
                      cliente.nome,
                      style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    subtitle: Text('NIF: ${cliente.NIF}'),
                  );
                },
              ),
            ),

            SizedBox(
              height: 50.0,
              width: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff00afe9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.black),
                  ),
                ),
                onPressed: () {
                  widget.pedido.clienteID = widget.clienteSelecionado.id;
                  if (widget.pedido.id != 0){
                    database.addPedido(widget.pedido);
                  }
                  Navigator.pop(context);
                  //Navigator.pop(context);
                  //Navigator.of(context).push(
                  //    MaterialPageRoute(builder: (context) => CarrinhoPage(
                  //        pedidos: widget.pedidos,
                  //        artigos: widget.artigos,
                  //        pedido: widget.pedido)));
                },
                child: const Text('SALVAR',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
