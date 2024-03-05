import 'package:objectbox/objectbox.dart';
import '../database/objectbox.g.dart';

@Entity()
class TurnoObj {
  int id = 0;
  bool turnoAberto = false;

  @Property(type: PropertyType.date)
  late DateTime horaAbertura;

  @Property(type: PropertyType.date)
  late DateTime horaFecho;

  late double vendasBrutas;
  late double reembolsos;
  late double descontos;
  late double vendasliquidas;
  late double dinheiro;    // ?? não sei como fazer isto porque pode ter ou não ter estas :/
  late double multibanco;  // ?? não sei como fazer isto porque pode ter ou não ter estas :/
  late double mbWay;       // ?? não sei como fazer isto porque pode ter ou não ter estas :/
  late double dinheiroInicial;
  late double pagamentosDinheiro;
  late double suprimento;
  late double sangria;
  late double dinheiroEsperado;


  late int funcionarioID;

  TurnoObj();
}