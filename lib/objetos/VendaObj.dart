import '../main.dart';
import 'package:objectbox/objectbox.dart';
import '../database/objectbox.g.dart';

@Entity()
class VendaObj {
  int id = 0;
  String nome;
  bool anulada = false;

  @Property(type: PropertyType.date)
  DateTime hora;


  late List<int> artigosPedidoIds = [];

  int funcionarioID;
  int localId ;

  double total = 0;
  int nrArtigos = 0;

  VendaObj({
    required this.nome,
    required this.hora,
    required this.funcionarioID,
    required this.localId,
    required this.total,
  });


  double calcularValorTotal() {
    total=0;
    for (var artigoId in artigosPedidoIds) {
      total += database.getArtigo(artigoId)!.price;
    }
    return total;
  }
}
