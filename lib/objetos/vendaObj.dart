import 'utilizadorObj.dart';
import 'artigoObj.dart';

class VendaObj {
  String nome;
  DateTime hora;
  List<Artigo> artigosPedido = [];
  String local; // DEVERÁ SER UM OBJETO ??
  Utilizador funcionario;

  VendaObj({
    required this.nome,
    required this.hora,
    required this.local,
    required this.funcionario,
  });
}
