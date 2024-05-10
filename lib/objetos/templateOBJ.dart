import 'package:objectbox/objectbox.dart';

@Entity()
class TemplateOBJ {
  @Id(assignable: true)
  int id = 0;
  String content;

  @Property(type: PropertyType.date)
  DateTime hora;

  TemplateOBJ(this.content, this.hora);
}
