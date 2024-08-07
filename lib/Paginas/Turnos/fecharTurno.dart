import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:it4billing_pos/objetos/metodoPagamentoObj.dart';
import 'package:it4billing_pos/Paginas/Turnos/turnoFechado.dart';

import '../../main.dart';
import '../../objetos/turnoObj.dart';

class FecharTurno extends StatefulWidget {
  @override
  _FecharTurnoState createState() => _FecharTurnoState();
}

class _FecharTurnoState extends State<FecharTurno> {
  TurnoObj turno = database.getAllTurno()[0];
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  double dinheiroReal = 0.00;


  @override
  void initState() {
    super.initState();
    _textEditingController.text = turno.dinheiroEsperado.toStringAsFixed(2);
    calcularDiferenca(); // Calcular a diferença logo após a página carregar
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && _textEditingController.text.isEmpty) {
      setState(() {
        _textEditingController.text = turno.dinheiroEsperado.toStringAsFixed(2);
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
        FocusScope.of(context).unfocus();
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
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Quantidade de dinheiro esperado:',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    turno.dinheiroEsperado.toStringAsFixed(2),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Quantidade de dinheiro real:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 50.0),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _textEditingController,
                      focusNode: _focusNode,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      textAlign: TextAlign.right,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      onChanged: (value) {
                        calcularDiferenca(); // Recalcular a diferença quando o valor real muda
                      },
                      onTap: () {
                        setState(() {
                          if (_textEditingController.text == turno.dinheiroEsperado.toStringAsFixed(2)) {
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
              const SizedBox(height: 10.0),
              const Divider(),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Diferença:',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    (dinheiroReal - turno.dinheiroEsperado).toStringAsFixed(2), // Exibir a diferença calculada
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: double.infinity,
            height: 50.0,
            child: ElevatedButton(
              onPressed: () async {
                if (database.getAllPedidos().isEmpty){
                  turno.turnoAberto = false;
                  await database.removeAllTurno();
                  TurnoObj novoturno = TurnoObj();
                  novoturno.funcionarioID = database.getAllSetup()[0].funcionarioId;

                  //limpar os valores dos movimentos
                  List<MetodoPagamentoObj> metudos = database.getAllMetodosPagamento();
                  for (int i = 0 ; i < metudos.length ; i++ ){
                    metudos[i].valor = 0;
                    database.addMetodoPagamento(metudos[i]);
                  }

                  database.addTurno(novoturno);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TurnoFechado()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ainda existem pedidos abertos.'),
                    ),
                  );
                }


              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffad171b),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: const BorderSide(color: Colors.black),
                ),
              ),
              child: const Text(
                'FECHAR TURNO',
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
