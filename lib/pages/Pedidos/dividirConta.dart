import 'package:flutter/material.dart';

import '../../objetos/pedidoObj.dart';

class DividirConta extends StatefulWidget {
  late PedidoObj pedido;

  DividirConta({
    Key? key,
    required this.pedido,
  }) : super(key: key);

  @override
  _DividirConta createState() => _DividirConta();
}

class _DividirConta extends State<DividirConta> {
  int numPessoas = 2; // Começa com dois
  // Valor total do pedido
  List<double> valoresIndividuais = []; // Valores individuais de cada pessoa

  @override
  void initState() {
    super.initState();
    calcularValoresIndividuais();
  }

  void calcularValoresIndividuais() {
    double totalPedido = widget.pedido.total;
    setState(() {
      valoresIndividuais.clear();
      double valorIndividual = double.parse((totalPedido / numPessoas).toStringAsFixed(2)); // Arredondar para 2 casas decimais
      double totalFixo = double.parse((valorIndividual * numPessoas).toStringAsFixed(2));
      double diferenca = totalPedido - totalFixo;
      double diferencaPorPessoa = (diferenca / 0.01).abs();

      for (int i = 0; i < numPessoas; i++) {
        double valor = valorIndividual;
        if (diferenca > 0 && diferencaPorPessoa > 0) {
          valor += 0.01;
          diferenca -= 0.01;
          diferencaPorPessoa--;
        }
        if (diferenca < 0 && diferencaPorPessoa > 0) {
          valor -= 0.01;
          diferenca += 0.01;
          diferencaPorPessoa--;
        }
        valoresIndividuais.add(double.parse(valor.toStringAsFixed(2))); // Garantir 2 casas decimais
      }

      // Ajuste para garantir que a soma seja igual ao total do pedido
      valoresIndividuais[0] += totalPedido - valoresIndividuais.reduce((value, element) => value + element);
    });
  }

  void aumentarPessoas() {
    setState(() {
      numPessoas++;
      calcularValoresIndividuais();
    });
  }

  void diminuirPessoas() {
    if (numPessoas > 2) {
      setState(() {
        numPessoas--;
        calcularValoresIndividuais();
      });
    }
  }

  void cobrarValor(int index) {
    // Implemente a lógica para cobrar o valor da pessoa com o índice 'index'
    // Aqui você pode realizar a ação necessária, como registrar o pagamento, etc.
    print("Cobrar valor da pessoa ${index + 1}: ${valoresIndividuais[index]}");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dividir Conta'),
        backgroundColor: const Color(0xff00afe9),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: diminuirPessoas,
              ),
              Text(
                '$numPessoas Clientes',
                style: const TextStyle(fontSize: 20),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: aumentarPessoas,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Total do Pedido: ${widget.pedido.total.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: numPessoas,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Valor da clientes ${index + 1}: ${valoresIndividuais[index].toStringAsFixed(2)} €'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      cobrarValor(index);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xff00afe9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.black),
                      ),
                    ),
                    child: const Text('Cobrar'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
