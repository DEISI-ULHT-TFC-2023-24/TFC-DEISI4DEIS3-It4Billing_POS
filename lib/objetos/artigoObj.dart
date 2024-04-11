import 'package:objectbox/objectbox.dart';
import '../database/objectbox.g.dart';


@Entity()
class Artigo {
  int id = 0;
  String referencia;
  String nome;
  String barCod;
  String description;
  String productType;

  late double price; //valor com iva
  late double discount = 0;
  double unitPrice; // Valor sem iva

  int idArticlesCategories;

  int idTaxes; // ID da tabela taxas do it4billing
  int taxPrecentage;
  String taxName; // exemplo: taxa inermedia, isenta, taxa normal, ect...
  String taxDescription; //para isenções de IVA, ou seja taxa de iva a zero

  int idRetention;
  int retentionPercentage;
  String retentionName;

  int stock;
  String observacoes = '';

  Artigo({
      required this.referencia,
      required this.nome,
      required this.barCod,
      required this.description,
      required this.productType,
      required this.unitPrice,
      required this.idTaxes,
      required this.taxPrecentage,
      required this.taxName,
      required this.taxDescription,
      required this.idRetention,
      required this.retentionPercentage,
      required this.retentionName,
      required this.stock,
      required this.idArticlesCategories,
  }){
    calcolarPrice();
  }

  void calcolarPrice(){
    price = double.parse((unitPrice * (taxPrecentage / 100 + 1)).toStringAsFixed(2));
  }
}
