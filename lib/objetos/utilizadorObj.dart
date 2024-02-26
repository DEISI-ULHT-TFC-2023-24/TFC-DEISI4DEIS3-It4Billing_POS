import 'package:objectbox/objectbox.dart';
import '../database/objectbox.g.dart';

@Entity()
class Utilizador {
  int id = 0;
  String nome;
  int pin;

  Utilizador(this.nome, this.pin);
}