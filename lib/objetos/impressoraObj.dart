import 'package:objectbox/objectbox.dart';
import '../database/objectbox.g.dart';

@Entity()
class ImpressoraObj {
  int id = 0;
  String nome  = '';
  String iP = '';


  ImpressoraObj(this.nome,this.iP);
}