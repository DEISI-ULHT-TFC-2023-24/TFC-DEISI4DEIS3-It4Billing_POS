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
  int nrArtigos = 0;

  PedidoObj({
    required this.nome,
    required this.hora,
    required this.funcionario,
    required this.total,
  });

  double calcularValorTotal() {
    total=0;
    for (var artigo in artigosPedido) {
      total += artigo.price;
    }
    return total;
  }
}
