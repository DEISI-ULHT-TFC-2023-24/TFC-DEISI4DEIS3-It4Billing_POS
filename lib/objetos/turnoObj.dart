import 'package:objectbox/objectbox.dart';
import '../database/objectbox.g.dart';
import '../main.dart';
import 'metodoPagamentoObj.dart';

@Entity()
class TurnoObj {
  int id = 0;
  bool turnoAberto = false;
  List<int> metodosIds = database.getAllMetodosPagamentoIds();

  @Property(type: PropertyType.date)
  late DateTime horaAbertura = DateTime.now();

  @Property(type: PropertyType.date)
  late DateTime horaFecho = DateTime.now();

  late double vendasBrutas = calcularVendasBrutas();
  double reembolsos = 0;
  double descontos = 0;
  late double vendasliquidas = calcularVendasLiquidas();


  double dinheiroInicial = 0;
  double pagamentosDinheiro = 0;
  double reembolsosDinheiro = 0;
  double suprimento = 0;
  double sangria = 0;
  late double dinheiroEsperado = calcularDinheiroEsperado();

  int funcionarioID = 0;

  TurnoObj();

// Função para calcular o valor das vendas brutas
  double calcularVendasBrutas() {
    var valor = 0.0;
    for(var metudoId in metodosIds){
      valor += database.getMetodoPagamento(metudoId)!.valor;
    }
    return valor;
  }
  // Função para calcular o valor das vendas liquidas
  double calcularVendasLiquidas() {
    return calcularVendasBrutas() - reembolsos - descontos;
  }

  // Setter para dinheiroInicial
  @Transient()
  set setMetudo(double valor) {
    vendasBrutas = calcularVendasBrutas();
    vendasliquidas = calcularVendasLiquidas();
  }


  // Função para calcular o valor do dinheiro esperado
  double calcularDinheiroEsperado() {
    return dinheiroInicial +
        pagamentosDinheiro -
        reembolsosDinheiro +
        suprimento -
        sangria;
  }


  // Setter para dinheiroInicial
  @Transient()
  set setDinheiroInicial(double valor) {
    dinheiroInicial = valor;
    dinheiroEsperado = calcularDinheiroEsperado();
  }

  // Setter para pagamentosDinheiro
  @Transient()
  set setPagamentosDinheiro(double valor) {
    pagamentosDinheiro = valor;
    dinheiroEsperado = calcularDinheiroEsperado();
  }

  // Setter para reembolsosDinheiro
  @Transient()
  set setReembolsosDinheiro(double valor) {
    reembolsosDinheiro = valor;
    dinheiroEsperado = calcularDinheiroEsperado();
  }

  // Setter para suprimento
  @Transient()
  set setSuprimento(double valor) {
    suprimento = valor;
    dinheiroEsperado = calcularDinheiroEsperado();
  }

  // Setter para sangria
  @Transient()
  set setSangria(double valor) {
    sangria = valor;
    dinheiroEsperado = calcularDinheiroEsperado();
    print('estive aqui na sangria');
  }


}