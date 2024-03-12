import 'package:flutter/material.dart';
import 'package:it4billing_pos/objetos/clienteObj.dart';

import '../../main.dart';

class NovoClientePage extends StatefulWidget {
  final ClienteObj cliente = ClienteObj('N/D', 999999990, 'N/D', 'N/D',
      '0000-000', 'N/D', 'N/D', 987654321, 'N/D');

  NovoClientePage({super.key});

  @override
  _NovoClientePageState createState() => _NovoClientePageState();
}

class _NovoClientePageState extends State<NovoClientePage> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController nifController = TextEditingController();
  TextEditingController paisController = TextEditingController();
  TextEditingController enderecoController = TextEditingController();
  TextEditingController codigoPostalController = TextEditingController();
  TextEditingController cidadeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();
  TextEditingController observacoesController = TextEditingController();

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
        title: const Text('Criar novo cliente'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          _buildListTile(
            label: 'Nome do Cliente',
            controller: nomeController,
            icon: Icons.person,
          ),
          _buildListTile(
            label: 'NIF',
            controller: nifController,
            icon: Icons.credit_card,
            keyboardType: TextInputType.number,
          ),
          _buildListTile(
            label: 'País',
            controller: paisController,
            icon: Icons.location_on,
          ),
          _buildListTile(
            label: 'Endereço',
            controller: enderecoController,
            icon: Icons.location_city,
          ),
          _buildListTile(
            label: 'Código Postal',
            controller: codigoPostalController,
            icon: Icons.mail,
          ),
          _buildListTile(
            label: 'Cidade',
            controller: cidadeController,
            icon: Icons.location_city,
          ),
          _buildListTile(
            label: 'Email',
            controller: emailController,
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
          ),
          _buildListTile(
            label: 'Telefone',
            controller: telefoneController,
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
          ),
          _buildListTile(
            label: 'Observações',
            controller: observacoesController,
            icon: Icons.note,
          ),
          const SizedBox(height: 20,),
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
              onPressed: () async {
                atualizarValoresCliente();
                await database.addCliente(widget.cliente);
                Navigator.pop(context);
              },
              child: const Text(
                'SALVAR',
                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        keyboardType: keyboardType,
      ),
    );
  }

  void atualizarValoresCliente() {
    if (nomeController.text.isNotEmpty) {
      widget.cliente.nome = nomeController.text;
    }

    String nifText = nifController.text;
    if (nifText.isNotEmpty) {
      widget.cliente.NIF = int.tryParse(nifText) ?? 0;
    }

    if (paisController.text.isNotEmpty) {
      widget.cliente.country = paisController.text;
    }

    if (enderecoController.text.isNotEmpty) {
      widget.cliente.address = enderecoController.text;
    }

    if (codigoPostalController.text.isNotEmpty) {
      widget.cliente.postcode = codigoPostalController.text;
    }

    if (cidadeController.text.isNotEmpty) {
      widget.cliente.city = cidadeController.text;
    }

    if (emailController.text.isNotEmpty) {
      widget.cliente.email = emailController.text;
    }

    String telefoneText = telefoneController.text;
    if (telefoneText.isNotEmpty) {
      widget.cliente.phone = int.tryParse(telefoneText) ?? 0;
    }

    if (observacoesController.text.isNotEmpty) {
      widget.cliente.obeservations = observacoesController.text;
    }
  }

}
