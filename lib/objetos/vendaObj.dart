import 'utilizadorObj.dart';
import 'artigoObj.dart';

class VendaObj {
  String nome;
  DateTime hora;
  List<Artigo> artigosPedido = [];
  late String local; // DEVERÁ SER UM OBJETO ??
  late Utilizador funcionario;

  VendaObj({required this.nome, required this.hora});
}
