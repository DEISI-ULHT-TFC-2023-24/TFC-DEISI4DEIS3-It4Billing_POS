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
  double suprimento = 0;
  double sangria = 0;
  double dinheiroEsperado = 0;


  int funcionarioID = 0;

  TurnoObj();
}