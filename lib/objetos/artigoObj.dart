import 'categoriaObj.dart';

class Artigo {
  String referencia;
  String nome;
  String barCod;
  String description;
  String productType;

  double unitPrice; // Valor sem iva

  int idArticlesCategories; // por tabela ???? acho que não
  Categoria categoria; // por objeto

  int idTaxes; // ID da tabela taxas do it4billing
  int taxPrecentage;
  String taxName; // exemplo: taxa inermedia, isenta, taxa normal, ect...
  String taxDescription; //para isenções de IVA, ou seja taxa de iva a zero

  int idRetention;
  int retentionPercentage;
  String retentionName;

  Artigo({
      required this.referencia,
      required this.nome,
      required this.barCod,
      required this.description,
      required this.productType,
      required this.unitPrice,
      required this.idArticlesCategories,
      required this.categoria,
      required this.idTaxes,
      required this.taxPrecentage,
      required this.taxName,
      required this.taxDescription,
      required this.idRetention,
      required this.retentionPercentage,
      required this.retentionName});
}
