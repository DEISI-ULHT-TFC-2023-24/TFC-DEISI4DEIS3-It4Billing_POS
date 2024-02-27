import 'package:flutter/cupertino.dart';
import 'package:objectbox/objectbox.dart';
import '../database/objectbox.g.dart';

@Entity()
class Setup {
  int id = 0;
  String url;
  String password;

  late int lojaID;  //escolher um dos dois
  late String nomeLoja;

  late int posID;
  late String pos;

  late int utilizadorID;

  late int faturacaoID;//escolher um dos dois
  late String faturacao;

  late int reembolsoID;//escolher um dos dois
  late String reembolso;

  late int contaCorrenteID;//escolher um dos dois
  late String contaCorrente;

  Setup({
    required this.url,
    required this.password,
  });

}