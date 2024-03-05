import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:it4billing_pos/pages/Turnos/turno.dart';

class TurnoFechado extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Chamando unfocus para perder o foco do campo de entrada
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Turnos'),
          backgroundColor: const Color(0xff00afe9),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Introduza o valor do dinheiro que está na sua gaveta no início do turno:',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.center,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d+\.?\d{0,2}'),
                  ),
                ],
                decoration: const InputDecoration(
                  hintText: '0.00 €',
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: SizedBox(
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () {
                        // Lógica para abrir o turno aqui

                        /// Logica oara a BD local Zé

                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Turnos()));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xff00afe9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(color: Colors.black),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Abrir Turno',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
