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

    // Check if types is in Firebase format (simple list) or PokeAPI format (nested objects)
    if (json['types'] != null) {
      for (var typeData in json['types']) {
        if (typeData is String) {
          // Firebase format: ["electric", "fire"]
          typesList.add(typeData);
        } else if (typeData is Map && typeData['type'] != null) {
          // PokeAPI format: [{type: {name: "electric"}}]
          typesList.add(typeData['type']['name']);
        }
      }
    }

    // Handle sprite URL - check both Firebase and PokeAPI formats
    String spriteUrl = '';
    if (json['sprite'] != null) {
      // Firebase format
      spriteUrl = json['sprite'];
    } else if (json['sprites'] != null && json['sprites']['front_default'] != null) {
      // PokeAPI format
      spriteUrl = json['sprites']['front_default'];
    }

    return Pokemon(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      name: json['name'] ?? '',
      types: typesList,
      sprite: spriteUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'types': types,
      'sprite': sprite,
    };
  }
}