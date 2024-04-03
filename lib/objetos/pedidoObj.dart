import '../main.dart';
import 'package:objectbox/objectbox.dart';
import '../database/objectbox.g.dart';
import 'artigoObj.dart';

@Entity()
class PedidoObj {
  int id = 0;
  String nome;

  @Property(type: PropertyType.date)
  DateTime hora;

  late ToMany<Artigo> artigosPedido = ToMany<Artigo>();
  late List<int> artigosPedidoIds = [];

  int funcionarioID;
  int clienteID;
  int localId;

  double total = 0;
  int nrArtigos = 0;

  PedidoObj({
    required this.nome,
    required this.hora,
    required this.funcionarioID,
    required this.clienteID,
    required this.localId,
    required this.total,
  });

  double calcularValorTotal() {
    total = 0;
    for (var artigoId in artigosPedidoIds) {
      for (var artigo in artigosPedido){
        if (artigo.nome == database.getArtigo(artigoId)!.nome){
          total += artigo.price;
          break;
        }
      }
    }
    return total;
  }
}
