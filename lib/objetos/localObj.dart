import 'package:objectbox/objectbox.dart';
import '../database/objectbox.g.dart';

@Entity()
class LocalObj {
  int id = 0;
  final String nome;

  LocalObj(this.nome);
}