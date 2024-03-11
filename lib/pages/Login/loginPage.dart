import 'package:flutter/material.dart';
import 'package:it4billing_pos/main.dart';
import 'package:it4billing_pos/objetos/turnoObj.dart';
import '../../objetos/setupObj.dart';
import '../Pedidos/pedidos.dart';

class LoginPage extends StatefulWidget {
  SetupObj setup;
  LoginPage({Key? key, required this.setup}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void setState(VoidCallback fn) {
    if (database.getAllSetup().isNotEmpty){
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
                      const _Logo(),
                      _FormContent(setup: widget.setup,),
                    ],
                  )
                : Container(
                    padding: const EdgeInsets.all(32.0),
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Row(
                      children: [
                        Expanded(child: _Logo()),
                        Expanded(
                          child: Scrollbar(
                            child: SingleChildScrollView(
                              child: _FormContent(setup: widget.setup,),
                            ),
                          ),
                        ),
                      ],
                    ),


            )
        )
    );
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
            "Welcome!",

            /// colocar a loja e o Nº do POS

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
                if (value == null || value.isEmpty) {
                  return 'Introduzir o PIN';
                }

                if (value.length < 4 || value.length > 4) {                      // if (value.length != 4) {
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
                  )),
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
                          color: Colors.white,fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        )
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      setState(() {
                        _showConfirmation = true;
                      });

                      /// Tenho de fazer a verificação do pin com os empregados registados
                      /// digamos que vai ser o id 1
                      await criarTurno();
                      widget.setup.utilizadorID = database.getAllUtilizadores()[0].id;
                      print(database.getAllSetup().length);
                        print(database.getAllSetup().length);

                        if (database.getAllSetup().isEmpty){
                          await database.addSetup(widget.setup);
                          print('Não tenho setup');
                        } else {
                          print('Tenho setup e não criei outro'); /// para teste
                        }

                      print(database.getAllSetup().length);
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (BuildContext context) => PedidosPage()),
                              (route) => false);
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
    turno.funcionarioID = database.getAllUtilizadores()[0].id;
    /// verificar a possibilidade de outro utilizador querer usar enquanto esta outra conta logada
    // para o teste

    /// verificar a possibilidade de outro utilizador querer usar enquanto esta outra conta logada
    if (database.getAllTurnos().isEmpty){
      print('tenho turno');
      await database.addTurno(turno);
      print('adicionei sem problemas acho');
    }
  }
}
