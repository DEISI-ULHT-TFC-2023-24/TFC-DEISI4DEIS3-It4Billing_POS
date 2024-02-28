import 'package:objectbox/objectbox.dart';
import '../database/objectbox.g.dart';
import '../main.dart';
import 'artigoObj.dart';

@Entity()
class Categoria {
  int id = 0;
  String nome;
  String nomeCurto;
  String description;
  late int nrArtigos =0;

  Categoria({
      required this.nome,
      required this.nomeCurto,
      required this.description
  });

  /*void calcularNrArtigos() async {

    List<Categoria> allCategorias = database.getAllCategorias();
    List<Artigo> allArtigos = database.getAllArtigos();

    //final List<Artigo> finalArtigos = allArtigos
    //    .where((artigo) => allCategorias.any((categoria) => categoria.id == artigo.idArticlesCategories))
    //    .toList();
/// para testes de prints de pois alterar outra vez
    List<Artigo> finalArtigos = [];
    for (Categoria categoria in allCategorias) {
      print('------');
      print('Nome do CATEGORIA a verificar ${categoria.nome}');
      for (Artigo artigo in allArtigos) {
        print('Nome do ARTIGO a verificar ${artigo.nome}');
        print('categoria.id: ${categoria.id}  artigo.idArticlesCategories: ${artigo.idArticlesCategories}');
        if (categoria.id == artigo.idArticlesCategories) {
          finalArtigos.add(artigo);

          break; // Para evitar adicionar o mesmo artigo mais de uma vez
        }
      }
    }
    //print(finalArtigos.length);


    nrArtigos = finalArtigos.length;
  }*/

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Categoria &&
              runtimeType == other.runtimeType &&
              nome == other.nome &&
              description == other.description &&
              nomeCurto == other.nomeCurto;

  @override
  int get hashCode => nome.hashCode ^ description.hashCode ^ nomeCurto.hashCode;
}
