import 'package:objectbox/objectbox.dart';
import '../database/objectbox.g.dart';

@Entity()
class SetupObj {
  int id = 0;
  String url = '';
  String password = '';

  late int lojaID = 0;  //escolher um dos dois
  late String nomeLoja = '';

  late bool imprimir = false;
  late bool email = false;
  late bool notaCredito = false;

  late int posID = 0;
  late String pos = '';

  late int utilizadorID = 0;

  late int faturacaoID = 0;//escolher um dos dois
  late String faturacao = '';

  late int reembolsoID = 0;//escolher um dos dois
  late String reembolso = '';

  late int contaCorrenteID = 0;//escolher um dos dois
  late String contaCorrente = '';


  SetupObj();

}