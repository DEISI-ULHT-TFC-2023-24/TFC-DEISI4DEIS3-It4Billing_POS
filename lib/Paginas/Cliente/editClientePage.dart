import 'package:flutter/material.dart';
import 'package:it4billing_pos/main.dart';
import 'package:it4billing_pos/objetos/clienteObj.dart';

class EditarClientePage extends StatelessWidget {
  final ClienteObj cliente;

  EditarClientePage({required this.cliente});

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

    // Define os valores iniciais antes de exibir os TextFormFields
    nomeController.text = cliente.nome;
    nifController.text = cliente.NIF.toString();
    paisController.text = cliente.country;
    enderecoController.text = cliente.address;
    codigoPostalController.text = cliente.postcode;
    cidadeController.text = cliente.city;
    emailController.text = cliente.email;
    telefoneController.text = cliente.phone.toString();
    observacoesController.text = cliente.obeservations;

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
          _buildListTile(
            label: 'Nome do Cliente',
            controller: nomeController,
            icon: Icons.person, valorInicial: cliente.nome,
          ),
          _buildListTile(
            label: 'NIF',
            controller: nifController,
            icon: Icons.credit_card,
            keyboardType: TextInputType.number, valorInicial: cliente.NIF.toString(),
          ),
          _buildListTile(
            label: 'País',
            controller: paisController,
            icon: Icons.location_on, valorInicial: cliente.country,
          ),
          _buildListTile(
            label: 'Endereço',
            controller: enderecoController,
            icon: Icons.location_city, valorInicial: cliente.address,
          ),
          _buildListTile(
            label: 'Código Postal',
            controller: codigoPostalController,
            icon: Icons.mail, valorInicial: cliente.postcode,
          ),
          _buildListTile(
            label: 'Cidade',
            controller: cidadeController,
            icon: Icons.location_city, valorInicial: cliente.city,
          ),
          _buildListTile(
            label: 'Email',
            controller: emailController,
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress, valorInicial: cliente.email,
          ),
          _buildListTile(
            label: 'Telefone',
            controller: telefoneController,
            icon: Icons.phone,
            keyboardType: TextInputType.phone, valorInicial: cliente.phone.toString(),
          ),
          _buildListTile(
            label: 'Observações',
            controller: observacoesController,
            icon: Icons.note, valorInicial: cliente.obeservations,
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
                await database.addCliente(cliente);
                Navigator.pop(context);
              },
              child: const Text(
                  'SALVAR',
                  style:
                  TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required String valorInicial,
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
      cliente.nome = nomeController.text;
    }

    String nifText = nifController.text;
    if (nifText.isNotEmpty) {
      cliente.NIF = int.tryParse(nifText) ?? 0;
    }

    if (paisController.text.isNotEmpty) {
      cliente.country = paisController.text;
    }

    if (enderecoController.text.isNotEmpty) {
      cliente.address = enderecoController.text;
    }

    if (codigoPostalController.text.isNotEmpty) {
      cliente.postcode = codigoPostalController.text;
    }

    if (cidadeController.text.isNotEmpty) {
      cliente.city = cidadeController.text;
    }

    if (emailController.text.isNotEmpty) {
      cliente.email = emailController.text;
    }

    String telefoneText = telefoneController.text;
    if (telefoneText.isNotEmpty) {
      cliente.phone = int.tryParse(telefoneText) ?? 0;
    }

    if (observacoesController.text.isNotEmpty) {
      cliente.obeservations = observacoesController.text;
    }
  }
}
