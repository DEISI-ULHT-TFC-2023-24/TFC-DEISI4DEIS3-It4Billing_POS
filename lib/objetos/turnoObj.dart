import 'package:objectbox/objectbox.dart';
import '../database/objectbox.g.dart';

@Entity()
class TurnoObj {
  int id = 0;
  bool turnoAberto = false;

  @Property(type: PropertyType.date)
  late DateTime horaAbertura = DateTime.now();

  @Property(type: PropertyType.date)
  late DateTime horaFecho = DateTime.now();

  double vendasBrutas = 0;
  double reembolsos = 0;
  double descontos = 0;
  double vendasliquidas = 0;
  double dinheiro = 0;    // ?? não sei como fazer isto porque pode ter ou não ter estas :/ ou ter mais ainda 🤯
  double multibanco = 0;  // ?? não sei como fazer isto porque pode ter ou não ter estas :/ ou ter mais ainda 🤯
  double mbWay = 0;       // ?? não sei como fazer isto porque pode ter ou não ter estas :/ ou ter mais ainda 🤯
  double dinheiroInicial = 0;
  double pagamentosDinheiro = 0;
  double reembolsosDinheiro = 0;
  double suprimento = 0;
  double sangria = 0;
  late double dinheiroEsperado = calcularDinheiroEsperado();

  int funcionarioID = 0;

  TurnoObj();

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