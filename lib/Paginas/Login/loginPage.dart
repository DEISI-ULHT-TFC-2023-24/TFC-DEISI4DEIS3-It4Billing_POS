import 'package:flutter/material.dart';
import 'package:it4billing_pos/main.dart';
import 'package:it4billing_pos/objetos/turnoObj.dart';
import '../../objetos/setupObj.dart';
import '../Pedidos/pedidos.dart';

class LoginPage extends StatefulWidget {
  SetupObj setup = database.getAllSetup()[0];

  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void setState(VoidCallback fn) {
    if (database.getAllSetup().isNotEmpty) {
      widget.setup = database.getAllSetup()[0];
    }
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Center(
        child: isSmallScreen
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Logo(
                    setup: widget.setup,
                  ),
                  _FormContent(
                    setup: widget.setup,
                  ),
                ],
              )
            : Container(
                padding: const EdgeInsets.all(32.0),
                constraints: const BoxConstraints(maxWidth: 800),
                child: Row(
                  children: [
                    Expanded(
                        child: _Logo(
                      setup: widget.setup,
                    )),
                    Expanded(
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          child: _FormContent(
                            setup: widget.setup,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  SetupObj setup;

  _Logo({Key? key, required this.setup}) : super(key: key);

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
            "Bem-vindo à\n${setup.nomeLoja} !\n${setup.pos}",
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
  SetupObj setup;

  _FormContent({Key? key, required this.setup}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  bool _isPasswordVisible = false;
  bool _showConfirmation = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _pinController = TextEditingController();

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
              controller: _pinController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Introduzir o PIN';
                }

                if (value.length != 4) {
                  return 'A PIN deve ter 4 caracteres';
                }

                return null;
              },
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'PIN',
                hintText: 'Introduzir o PIN',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_isPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            _gap(),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff00afe9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.black),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'ENTRAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    setState(() {
                      _showConfirmation = true;
                    });

                    bool pinFound = false;

                    for (int i = 0; i < database.getAllFuncionarios().length; i++) {
                      if (database.getAllFuncionarios()[i].pin == int.parse(_pinController.text)) {
                        widget.setup.funcionarioId = database.getAllFuncionarios()[i].id;
                        await database.addSetup(widget.setup);
                        await criarTurno();
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => PedidosPage(),),(route) => false,);
                        pinFound = true;
                        break;
                      }
                    }
                    if (!pinFound) {
                      // Se o PIN não for encontrado, mostra o SnackBar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'PIN não existe. Por favor, tente novamente.'),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 20);

  Future<void> criarTurno() async {
    TurnoObj turno = TurnoObj();
    turno.funcionarioID = database.getAllSetup()[0].funcionarioId;

    if (database.getAllTurno().isEmpty) {
      await database.addTurno(turno);
    } else {
      turno = database.getAllTurno()[0];
      turno.funcionarioID = database.getAllSetup()[0].funcionarioId;
      await database.addTurno(turno);
    }
  }
}
