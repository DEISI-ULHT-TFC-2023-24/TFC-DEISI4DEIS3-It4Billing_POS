import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:it4billing_pos/main.dart';

import '../../objetos/transacoesObj.dart';
import '../../objetos/turnoObj.dart';

class CustomNumberTextInputFormatter extends TextInputFormatter {
  static const _defaultDoubleFormat = '0.00';

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final regEx = RegExp(r'^\d*\.?\d{0,2}');
    String newText = newValue.text;
    if (newText.isEmpty) {
      return newValue.copyWith(text: '');
    }
    if (!regEx.hasMatch(newText)) {
      return oldValue;
    }
    return newValue.copyWith(text: double.parse(newText).toStringAsFixed(2));
  }
}


class GestaoDinheiro extends StatefulWidget {

  @override
  _GestaoDinheiroState createState() => _GestaoDinheiroState();
}

class _GestaoDinheiroState extends State<GestaoDinheiro> {
  late TurnoObj turno;
  TextEditingController _moneyController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  List<TransactionObj> transactions = database.getAllTransactions();
  bool _canAddTransaction = false;

  @override
  void initState() {
    super.initState();
    turno = database.getAllTurno()[0]; // Inicializando turno
    _moneyController.addListener(_updateFormattedAmount);
  }

  @override
  void dispose() {
    _moneyController.removeListener(_updateFormattedAmount);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão do dinheiro'),
        backgroundColor: const Color(0xff00afe9),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _moneyController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                CustomNumberTextInputFormatter()
              ],
              decoration: const InputDecoration(
                hintText: 'Dinheiro a movimentar',
              ),
              onChanged: (_) {
                setState(() {
                  _canAddTransaction = _moneyController.text.isNotEmpty &&
                      _moneyController.text != '0.00';
                });
              },
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Descrição',
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _canAddTransaction
                      ? () {
                    turno.setSangria = turno.sangria + double.parse(_moneyController.text);
                    database.addTurno(turno);
                    _addTransaction();
                  }
                      : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        _canAddTransaction ? Colors.red : Colors.grey),
                  ),
                  child: const Text(
                    'SANGRIA',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: _canAddTransaction
                      ? () {
                    turno.setSuprimento = turno.suprimento + double.parse(_moneyController.text);
                    database.addTurno(turno);
                    _addTransaction();
                  }
                      : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        _canAddTransaction ? Colors.green : Colors.grey),
                  ),
                  child: const Text(
                    'SUPRIMENTO',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            const Divider(color: Colors.black54),
            const SizedBox(height: 10.0),
            const Text(
              'Suprimento / Sangria',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color(0xff00afe9),
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: transactions.length,
                separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                        '${transactions[index].time} - ${database.getFuncionario(turno.funcionarioID)?.nome} - ${transactions[index].description} - ${transactions[index].amount} €'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateFormattedAmount() {
    setState(() {
      _canAddTransaction =
          _moneyController.text.isNotEmpty && _moneyController.text != '0.00';
    });
  }

  void _addTransaction() {
    String currentTime = DateFormat.Hm().format(DateTime.now());
    TransactionObj newTransaction = TransactionObj(
      time: currentTime,
      description: _descriptionController.text,
      amount: _moneyController.text,
    );

    setState(() {
      transactions.add(newTransaction);
      database.addTransaction(newTransaction);
      _moneyController.clear();
      _descriptionController.clear();
      _canAddTransaction = false;
    });
  }
}

