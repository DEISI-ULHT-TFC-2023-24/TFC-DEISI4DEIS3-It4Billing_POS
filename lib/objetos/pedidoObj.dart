import 'package:it4billing_pos/objetos/localObj.dart';

import 'utilizadorObj.dart';
import 'artigoObj.dart';

class PedidoObj {
  String nome;
  DateTime hora;
  List<Artigo> artigosPedido = [];
  LocalObj local = LocalObj(''); // DEVERÁ SER UM OBJETO ??
  Utilizador funcionario;
  double total = 0;

  PedidoObj({
    required this.nome,
    required this.hora,
    required this.funcionario,
    required this.total,
  });

  double calcularValorTotal() {
    for (var artigo in artigosPedido) {
      total += artigo.unitPrice*(artigo.taxPrecentage/100+1);
    }
    return total;
  }
}
