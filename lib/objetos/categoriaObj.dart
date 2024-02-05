class Categoria {
  String nome;
  String nomeCurto;
  String description;

  Categoria({
      required this.nome,
      required this.nomeCurto,
      required this.description
  });

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
