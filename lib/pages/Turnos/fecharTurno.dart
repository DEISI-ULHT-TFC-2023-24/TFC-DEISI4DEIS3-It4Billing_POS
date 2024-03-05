import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:it4billing_pos/pages/Turnos/turnoFechado.dart';

class FecharTurno extends StatefulWidget {
  @override
  _FecharTurnoState createState() => _FecharTurnoState();
}

class _FecharTurnoState extends State<FecharTurno> {
  double dinheiroEsperado = 100.00;
  double dinheiroReal = 0.00;
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _textEditingController.text = dinheiroEsperado.toStringAsFixed(2);
    calcularDiferenca(); // Calcular a diferença logo após o carregamento da página
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && _textEditingController.text.isEmpty) {
      setState(() {
        _textEditingController.text = dinheiroEsperado.toStringAsFixed(2);
      });
      calcularDiferenca();
    }
  }

  void calcularDiferenca() {
    setState(() {
      double valorCampo = double.tryParse(_textEditingController.text) ?? 0.0;
      dinheiroReal = valorCampo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Remover o foco do campo de texto quando houver um clique em outra parte da tela
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Fechar Turno', style: TextStyle(color: Colors.black)),
          elevation: 0, // Remover a sombra da AppBar
        ),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Quantidade de dinheiro esperado:',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '${dinheiroEsperado.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Quantidade de dinheiro real:',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 50.0),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _textEditingController,
                      focusNode: _focusNode,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      textAlign: TextAlign.right,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      onChanged: (value) {
                        calcularDiferenca(); // Recalcular a diferença quando o valor real muda
                      },
                      onTap: () {
                        setState(() {
                          if (_textEditingController.text == dinheiroEsperado.toStringAsFixed(2)) {
                            _textEditingController.text = '';
                          }
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Insira o valor real',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Divider(),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Diferença:',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '${(dinheiroReal - dinheiroEsperado).toStringAsFixed(2)}', // Exibir a diferença calculada
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(20.0),
          child: SizedBox(
            width: double.infinity,
            height: 50.0,
            child: ElevatedButton(
              onPressed: () {
                // Ação ao pressionar o botão de fechar turno

                ///   falta a logica da BD local


                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TurnoFechado()));

              },
              style: ElevatedButton.styleFrom(
                primary: const Color(0xffad171b),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Colors.black),
                ),
              ),
              child: Text(
                'Fechar Turno',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }
}
