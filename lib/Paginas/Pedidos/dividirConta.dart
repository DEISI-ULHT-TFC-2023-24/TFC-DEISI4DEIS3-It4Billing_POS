import 'package:flutter/material.dart';
import 'package:it4billing_pos/Paginas/Pedidos/pedidos.dart';

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

  late List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    calcularValoresIndividuais();
    botaoPressionado = List.generate(numPessoas, (index) => false);

    // Inicialize os controllers e adicione listeners para limpar os campos quando ganharem foco
    controllers = List.generate(
      numPessoas,
          (index) {
        TextEditingController controller = TextEditingController(
          text: valoresIndividuais[index].toStringAsFixed(2),
        );
        controller.addListener(() {
          final text = controller.text;
          if (text.isNotEmpty) {
            valoresIndividuais[index] = double.parse(text);
          }
        });
        return controller;
      },
    );
  }

  @override
  void dispose() {
    // Dispose os controllers
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
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
    bool algumValorInvalido = false;
    double somaValores =
        valoresIndividuais.reduce((value, element) => value + element);

    if (somaValores < widget.pedido.total) {
      algumValorInvalido = true;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Dinheiro insuficiente.'),
            content: const Text(
                'A soma dos valores cobrados é inferior ao total do pedido.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      for (int i = 0; i < valoresIndividuais.length; i++) {
        if (valoresIndividuais[i] < 0.00) {
          algumValorInvalido = true;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Valor inserido é inválido.'),
                content: const Text(
                    'Por favor, insira um valor válido para prosseguir com a cobrança.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }
    }

    if (!algumValorInvalido) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CobrarDivididoPage(
            pedido: widget.pedido,
            valorCobrar: valoresIndividuais[index],
          ),
        ),
      ).then((troca) {
        if (troca) {
          setState(() {
            botaoPressionado[index] = troca;
            if (countPressedButtons() == numPessoas) {
              mostrarBotaoConcluir = true;
            }
          });
        }
      });
    }
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
    if (widget.pedido.id != 0) {
      if (database.getPedido(widget.pedido.id) != null) {
        database.removePedido(widget.pedido.id);
      }
    }

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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dividir Conta'),
          backgroundColor: const Color(0xff00afe9),
          leading: Visibility(
            visible: botaoPressionado.every((element) => element == false),
            child: IconButton(
              icon: const Icon(Icons.arrow_back), // Ícone padrão de voltar
              onPressed: () {
                // Navegar para a página anterior
                Navigator.pop(context, false);
              },
            ),
          ),
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
              'Total do Pedido: ${widget.pedido.total.toStringAsFixed(2)} €',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              'Total Recebido: ${valoresIndividuais.reduce((value, element) => value + element).toStringAsFixed(2)} €',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: numPessoas,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Row(
                      children: [
                        Text(
                          'Cliente ${index + 1}: € ',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            controller: controllers[index],
                            onTap: () {
                              // Limpe o campo quando ganhar foco
                              controllers[index].clear();
                            },
                            onEditingComplete: () {
                              // Atualize a lista de valores quando a edição for concluída
                              final text = controllers[index].text;
                              if (text.isNotEmpty) {
                                valoresIndividuais[index] = double.parse(text);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (botaoPressionado[index]) // Mostrar apenas quando o botão estiver cobrado
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                botaoPressionado[index] = false;
                              });
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                            label: const Text(
                              'Anular',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ElevatedButton(
                          onPressed: botaoPressionado[index]
                              ? null
                              : () => cobrarValor(index),
                          style: ElevatedButton.styleFrom(
                            primary: botaoPressionado[index] ? Colors.grey : const Color(0xff00afe9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: Colors.black),
                            ),
                          ),
                          child: Text(botaoPressionado[index] ? 'Cobrado' : 'Cobrar'),
                        ),
                      ],
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
                    child: const Text(
                      'CONCLUIR VENDA',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
