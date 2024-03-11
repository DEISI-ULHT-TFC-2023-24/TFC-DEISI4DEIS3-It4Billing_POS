import 'package:objectbox/objectbox.dart';
import '../database/objectbox.g.dart';

@Entity()
class ClienteObj {
  int id = 0;
  String nome  = '';
  int NIF = 0;
  String country = '';
  String address = '';
  String postcode = ''; // sera que deve ser int
  String city = '';
  String email = '';
  int phone = 0;
  String obeservations = '';

  ClienteObj(this.nome,this.NIF,this.country,this.address,this.postcode,this.city,this.email,this.phone,this.obeservations);
}