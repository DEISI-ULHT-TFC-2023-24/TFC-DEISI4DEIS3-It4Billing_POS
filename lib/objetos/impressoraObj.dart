import 'package:objectbox/objectbox.dart';
import '../database/objectbox.g.dart';

@Entity()
class ImpressoraObj {
  int id = 0;
  String nome  = '';
  String iP = '';
  int port = 0000;


  ImpressoraObj(this.nome,this.iP,this.port);
}