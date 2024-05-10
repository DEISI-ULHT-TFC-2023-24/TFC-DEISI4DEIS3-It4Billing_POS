import 'package:objectbox/objectbox.dart';

@Entity()
class TemplateOBJ {
  @Id(assignable: true)
  int id = 0;
  String content;

  TemplateOBJ(this.content);
}
