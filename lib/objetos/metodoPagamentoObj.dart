import 'package:objectbox/objectbox.dart';
import '../database/objectbox.g.dart';

@Entity()
class MetodoPagamentoObj {
  int id = 0;
  String nome;
  double valor;

  MetodoPagamentoObj(this.nome, this.valor);

}