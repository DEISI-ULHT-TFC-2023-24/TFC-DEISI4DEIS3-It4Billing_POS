import 'package:objectbox/objectbox.dart';
import '../database/objectbox.g.dart';

@Entity()
class TransactionObj {
  int id = 0;
  final String time;
  final String description;
  final String amount;

  TransactionObj(
      {required this.time, required this.description, required this.amount});
}