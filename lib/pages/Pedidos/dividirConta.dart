import 'package:flutter/material.dart';
import 'package:it4billing_pos/pages/Pedidos/pedidos.dart';

import '../../main.dart';
import '../../objetos/VendaObj.dart';
import '../../objetos/pedidoObj.dart';
import 'cobrarDividido.dart';

class DividirConta extends StatefulWidget {

  List<PedidoObj> pedidos = [];
  late PedidoObj pedido;


  DividirConta({
    Key? key,
    required this.pedidos,
    required this.pedido,
  }) : super(key: key);

  @override
  _DividirConta createState() => _DividirConta();
}

class _DividirConta extends State<DividirConta> {
  int numPessoas = 2; // Começa com dois
  List<double> valoresIndividuais = []; // Valores individuais de cada pessoa
  bool mostrarBotaoConcluir = false;
  List<bool> botaoPressionado = [];

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
      double valorIndividual = double.parse((totalPedido / numPessoas)
          .toStringAsFixed(2)); // Arredondar para 2 casas decimais
      double totalFixo =
          double.parse((valorIndividual * numPessoas).toStringAsFixed(2));
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
        valoresIndividuais.add(double.parse(
            valor.toStringAsFixed(2))); // Garantir 2 casas decimais
      }

      // Ajuste para garantir que a soma seja igual ao total do pedido
      valoresIndividuais[0] += totalPedido -
          valoresIndividuais.reduce((value, element) => value + element);
    });
  }

  void aumentarPessoas() {
    setState(() {
      numPessoas++;
      botaoPressionado.add(false);
      mostrarBotaoConcluir =
          false; // Se aumentar o número de pessoas, o botão "Concluir Venda" deve desaparecer
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

  // Adicione um método para contar quantos botões foram pressionados
  int countPressedButtons() {
    return botaoPressionado.where((pressed) => pressed).length;
  }



  void cobrarValor(int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CobrarDivididoPage(pedido: widget.pedido,))).then((troca) {
                  if (troca){
                    setState(() {
                      botaoPressionado[index] = troca;
                      if (countPressedButtons() == numPessoas) {
                        mostrarBotaoConcluir = true;
                      }
                    });
                  }

    });
  }

  void concluirVenda() {
    // Lógica para concluir a venda
    VendaObj venda = VendaObj(
        nome: widget.pedido.nome,
        hora: widget.pedido.hora,
        funcionarioID: widget.pedido.funcionarioID,
        localId: widget.pedido.localId,
        total: widget.pedido.total);
    venda.artigosPedidoIds = widget.pedido.artigosPedidoIds;
    venda.nrArtigos = widget.pedido.nrArtigos;

    database.addVenda(venda);
    database.removePedido(widget.pedido.id);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PedidosPage(),
      ),
    );
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
                  title: Text(
                      'Valor do cliente ${index + 1}: ${valoresIndividuais[index].toStringAsFixed(2)} €'),
                  trailing: ElevatedButton(
                    onPressed: botaoPressionado[index]
                        ? null
                        : () => cobrarValor(index),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: botaoPressionado[index] ? Colors.black : Colors.white,
                      backgroundColor: botaoPressionado[index]
                          ? Colors.grey
                          : const Color(0xff00afe9),
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
          if (mostrarBotaoConcluir == true)
            SizedBox(
                height: 50.0,
                child: ElevatedButton(
                  onPressed: concluirVenda,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff00afe9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: const BorderSide(color: Colors.black),
                    ),
                  ),
                  child: const Text('CONCLUIR VENDA'),
                )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
