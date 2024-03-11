import 'package:flutter/material.dart';
import 'package:it4billing_pos/objetos/clienteObj.dart';

class EditarClientePage extends StatelessWidget {
  final ClienteObj cliente;

  EditarClientePage({required this.cliente});

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
        title: const Text('Editar Cliente'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          // Adicione aqui os campos de edição com os valores do cliente
          TextFormField(
            initialValue: cliente.nome,
            decoration: InputDecoration(labelText: 'Nome do Cliente'),
          ),
          TextFormField(
            initialValue: cliente.NIF.toString(),
            decoration: InputDecoration(labelText: 'NIF'),
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            initialValue: cliente.country,
            decoration: InputDecoration(labelText: 'País'),
          ),
          TextFormField(
            initialValue: cliente.address,
            decoration: InputDecoration(labelText: 'Endereço'),
          ),
          TextFormField(
            initialValue: cliente.postcode,
            decoration: InputDecoration(labelText: 'Código Postal'),
          ),
          TextFormField(
            initialValue: cliente.city,
            decoration: InputDecoration(labelText: 'Cidade'),
          ),
          TextFormField(
            initialValue: cliente.email,
            decoration: InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
          ),
          TextFormField(
            initialValue: cliente.phone.toString(),
            decoration: InputDecoration(labelText: 'Telefone'),
            keyboardType: TextInputType.phone,
          ),
          TextFormField(
            initialValue: cliente.obeservations,
            decoration: InputDecoration(labelText: 'Observações'),
          ),
          // Adicione mais campos conforme necessário
        ],
      ),
    );
  }
}
