import 'package:flutter/material.dart';
import 'package:it4billing_pos/pages/Login/loginPage.dart';

class SetupPOSPage extends StatefulWidget {
  const SetupPOSPage({Key? key}) : super(key: key);

  @override
  _SetupPOSPageState createState() => _SetupPOSPageState();
}

class _SetupPOSPageState extends State<SetupPOSPage> {
  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
        body: Center(
            child: isSmallScreen
                ? const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _FormContent(),
                    ],
                  )
                : Container(
                    padding: const EdgeInsets.all(32.0),
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Scrollbar(
                            child: SingleChildScrollView(
                              child: _FormContent(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )));
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent({Key? key}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  String? _selectedDocInvoice;
  String? _selectedDocRefund;
  String? _selectedDocCurrentAccount;

  final List<String> _invoices = [
    'Documento da faturação',
    'F 1',
    'F 2',
    'F 3'
  ];
  final List<String> _refunds = [
    'Documento do reembolso',
    'R 1',
    'R 2',
    'R 3'
  ];
  final List<String> _cunrrentAccount = [
    'Documento da conta corrente',
    'Cc 1',
    'Cc 2',
    'Cc 3'
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Selecione o documento para a faturação:'),
            _gap(),
            DropdownButtonFormField<String>(
              isExpanded: true,
              value: _selectedDocInvoice,
              hint: const Text('Documento da faturação'),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              )),
              onChanged: (newValue) {
                setState(() {
                  _selectedDocInvoice = newValue!;
                });
              },
              items: _invoices.map<DropdownMenuItem<String>>((String? value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value!),
                );
              }).toList(),
            ),
            _gap(),
            const Text('Selecione o documento para o reembolso:'),
            _gap(),
            DropdownButtonFormField<String>(
              isExpanded: true,
              value: _selectedDocRefund,
              hint: const Text('Documento do reembolso'),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              )),
              onChanged: (newValue) {
                setState(() {
                  _selectedDocRefund = newValue!;
                });
              },
              items: _refunds.map<DropdownMenuItem<String>>((String? value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value!),
                );
              }).toList(),
            ),
            _gap(),
            const Text('Selecione o documento para a conta corrente:'),
            _gap(),
            DropdownButtonFormField<String>(
              isExpanded: true,
              value: _selectedDocCurrentAccount,
              hint: const Text('Documento da conta corrente'),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              )),
              onChanged: (newValue) {
                setState(() {
                  _selectedDocCurrentAccount = newValue!;
                });
              },
              items: _cunrrentAccount
                  .map<DropdownMenuItem<String>>((String? value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value!),
                );
              }).toList(),
            ),
            _gap(),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xff00afe9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.black),
                  ),
                ),
                onPressed: () {
                  if (_selectedDocInvoice != null &&
                      _selectedDocInvoice != 'Documento da faturação' &&
                      _selectedDocRefund != null &&
                      _selectedDocRefund != 'Documento do reembolso' &&
                      _selectedDocCurrentAccount != null &&
                      _selectedDocCurrentAccount != 'Documento da conta corrente') {
                    // Lógica para confirmar seleção os docs.


                    /// tem de guardar o tipo de doc na bd local


                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const LoginPage()),
                        (route) => false);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Por favor, selecione todos os documentos.'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
                child: const Text('Confirmar Seleções', style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 20);
}
