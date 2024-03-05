import 'package:flutter/material.dart';
import 'package:it4billing_pos/pages/Login/setupPOSPage.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({Key? key}) : super(key: key);

  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
        body: Center(
            child: isSmallScreen
                ? const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _Logo(),
                      _FormContent(),
                    ],
                  )
                : Container(
                    padding: const EdgeInsets.all(32.0),
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: const Row(
                      children: [
                        Expanded(child: _Logo()),
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

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/img/logo_it4Billing.png'),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Bem vindo!",
            textAlign: TextAlign.center,
            style: isSmallScreen
                ? Theme.of(context).textTheme.headline5
                : Theme.of(context)
                    .textTheme
                    .headline4
                    ?.copyWith(color: Colors.black),
          ),
        )
      ],
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent({Key? key}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  bool _isPasswordVisible = false;
  bool _showConfirmation = false;
  String? _selectedStore;
  String? _selectedPos;
  final List<String> _stores = ['Selecione a loja', 'Loja 1', 'Loja 2', 'Loja 3'];
  final List<String> _poss = ['Selecione o POS', 'POS 1', 'POS 2', 'POS 3'];

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
            TextFormField(
              validator: (value) {
                // add email validation
                if (value == null || value.isEmpty) {
                  return 'Pintroduza um URL válido';
                }

                //bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
                bool emailValid = true; //para testes

                if (!emailValid) {
                  return 'Introduza um URL válido';
                }

                return null;
              },
              decoration: InputDecoration(
                labelText: 'URL',
                hintText: 'Introduza o URL',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            _gap(),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }

                if (value.length < 6) {
                  return 'A palavra-passe deve ter pelo menos 6 caracteres';
                }
                return null;
              },
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                  labelText: 'Palavra-passe',
                  hintText: 'Introduzir a palavra-passe',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )),
            ),
            _gap(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Conectar',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          setState(() {
                            _showConfirmation = true;
                          });
                        }
                      },
                    ),
                  ),
                if (_showConfirmation)
                  const Row(children: [SizedBox(width: 20), Icon(Icons.check_circle, color: Colors.green),],)
              ],
            ),
            if (_showConfirmation)
            Column(
              children: [
                _gap(),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: _selectedStore,
                  decoration: InputDecoration(
                      label: const Text('Loja', style: TextStyle(fontSize: 20)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      )),
                  hint: const Text('Selecione a loja'),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedStore = newValue!;
                    });
                  },
                  items: _stores.map<DropdownMenuItem<String>>((String? value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value!),
                    );
                  }).toList(),
                ),
                //if (_selectedStore != null && _selectedStore != 'Selecione a loja')
                Column(
                  children: [
                    _gap(),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: _selectedPos,
                      hint: const Text('Selecione o POS'),
                      decoration: InputDecoration(
                          label:
                              const Text('POS', style: TextStyle(fontSize: 20)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          )
                      ),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedPos = newValue!;
                        });
                      },
                      items:
                          _poss.map<DropdownMenuItem<String>>((String? value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value!),
                        );
                      }).toList(),
                    ),
                  ],
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
                      if (_selectedStore != null &&
                          _selectedStore != 'Selecione a loja' &&
                          _selectedPos != null &&
                          _selectedPos != 'Selecione o POS') {
                        // Lógica para confirmar seleção da loja e do POS

                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                const SetupPOSPage()),
                                (route) => false);
                      } else {
                        // Exibir mensagem de erro.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Por favor, selecione a loja e o POS.'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }

                    },
                    child: const Text('Entrar',
                        style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 20);
}
