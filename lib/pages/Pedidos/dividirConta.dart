import 'package:flutter/material.dart';

import '../../objetos/pedidoObj.dart';
import 'cobrarDividido.dart';

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
  List<bool> botaoPressionado = [];
  bool mostrarBotaoConcluir = false;

  @override
  void initState() {
    super.initState();
    calcularValoresIndividuais();
    botaoPressionado = List.generate(numPessoas, (index) => false);
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
      botaoPressionado.add(false);
      mostrarBotaoConcluir = false; // Se aumentar o número de pessoas, o botão "Concluir Venda" deve desaparecer
      calcularValoresIndividuais();
    });
  }

  void diminuirPessoas() {
    if (numPessoas > 2) {
      setState(() {
        numPessoas--;
        botaoPressionado.removeLast();
        calcularValoresIndividuais();
      });
    }
  }


  //void cobrarValor(int index) {
  //  setState(() {
  //    botaoPressionado[index] = true; // Marca o botão como pressionado
  //    // Implemente outras lógicas aqui, se necessário
  //  });
//
  //  /// ir para a pagina de combrança diferente não pode ser a mesma acho
//
  //  // Implemente a lógica para cobrar o valor da pessoa com o índice 'index'
  //  // Aqui você pode realizar a ação necessária, como registrar o pagamento, etc.
  //  print("Cobrar valor da pessoa ${index + 1}: ${valoresIndividuais[index]}");
  //}
  // Adicione um método para contar quantos botões foram pressionados
  int countPressedButtons() {
    return botaoPressionado.where((pressed) => pressed).length;
  }

  void cobrarValor(int index) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CobrarDividido(pedido: widget.pedido)))
        .then((_) {
      setState(() {
        botaoPressionado[index] = true;
        if (countPressedButtons() == numPessoas) {
          mostrarBotaoConcluir = true;
        }
      });
    });
  }

  void concluirVenda() {
    // Lógica para concluir a venda
    print('Venda concluída!');
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
                icon: const Icon(Icons.remove),
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
                  title: Text('Valor do cliente ${index + 1}: ${valoresIndividuais[index].toStringAsFixed(2)} €'),
                  trailing: ElevatedButton(
                    onPressed:  botaoPressionado[index] ? null : () => cobrarValor(index),
                    style: ElevatedButton.styleFrom(
                      primary: botaoPressionado[index] ? Colors.grey : const Color(0xff00afe9),
                      onPrimary:botaoPressionado[index] ? Colors.black : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.black),
                      ),
                    ),
                    child: Text(botaoPressionado[index] ? 'Cobrado' : 'Cobrar'),
                  ),
                );
              },
            ),
          ),
          if (mostrarBotaoConcluir == true) ElevatedButton(onPressed: concluirVenda, child: const Text('Concluir Venda'),),
        ],
      ),
    );
  }
}
