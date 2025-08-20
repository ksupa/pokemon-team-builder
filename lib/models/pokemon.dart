class Pokemon {
  final int id;
  final String name;
  final List<String> types;
  final String sprite;

  Pokemon({
    required this.id,
    required this.name,
    required this.types,
    required this.sprite
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    List<String> typesList = [];

    for(var typeData in json['types']) {
      typesList.add(typeData['type']['name']);
    }

    return Pokemon(
        id: json['id'],
        name: json['name'],
        types: typesList,
        sprite: json['sprites']['front_default'] ?? '',
    );
  }
}