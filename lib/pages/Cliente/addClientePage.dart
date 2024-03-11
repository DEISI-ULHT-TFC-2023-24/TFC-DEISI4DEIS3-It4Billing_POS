import 'package:flutter/material.dart';
import 'package:it4billing_pos/main.dart';
import 'package:it4billing_pos/objetos/clienteObj.dart';

import 'editClientePage.dart';

class AdicionarClientePage extends StatefulWidget {
  List<ClienteObj> clientes = database.getAllClientes();
  ClienteObj clienteSelecionado = database.getAllClientes()[0];

  @override
  _AdicionarClientePageState createState() => _AdicionarClientePageState();
}

class _AdicionarClientePageState extends State<AdicionarClientePage> {
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      // Implementar ação para editar o cliente
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => EditarClientePage(cliente: widget.clienteSelecionado,)));
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
                                    fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              Text('${widget.clienteSelecionado.NIF}', style: const TextStyle(color: Colors.black),),
                            ],
                          ),
                          const Text('Editar', style: TextStyle(color: Colors.black),),
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
              },
              child: const Text('Adicionar novo cliente', style: TextStyle(color: Colors.black),),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: widget.clientes.length,
                itemBuilder: (context, index) {
                  ClienteObj cliente = widget.clientes[index];
                  return ListTile(
                    onTap: () {
                      selecionarCliente(cliente);
                    },
                    title: Text(
                      cliente.nome,
                      style: const TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black ),
                    ),
                    subtitle: Text('NIF: ${cliente.NIF}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
