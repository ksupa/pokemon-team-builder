import 'pokemon.dart';

class Team {
  final String name;
  final List<Pokemon?> pokemon;
  final DateTime createdAt;
  final String? id; // For Firebase storage later

  Team({
    required this.name,
    required this.pokemon,
    required this.createdAt,
    this.id,
  });

  // Create empty team
  Team.empty(String teamName)
      : name = teamName,
        pokemon = List.filled(6, null),
        createdAt = DateTime.now(),
        id = null;

  // Helper methods
  bool get isFull => pokemon.every((p) => p != null);
  int get pokemonCount => pokemon.where((p) => p != null).length;

  bool containsPokemon(Pokemon pokemon) {
    return this.pokemon.any((p) => p?.id == pokemon.id);
  }

  void addPokemonToSlot(int slotIndex, Pokemon pokemon) {
    if (slotIndex < 0 || slotIndex >= 6) {
      throw ArgumentError('Slot index must be between 0 and 5');
    }
    if (containsPokemon(pokemon)) {
      throw ArgumentError('${pokemon.name} is already in this team');
    }
    this.pokemon[slotIndex] = pokemon;
  }

  void removePokemonFromSlot(int slotIndex) {
    if (slotIndex < 0 || slotIndex >= 6) {
      throw ArgumentError('Slot index must be between 0 and 5');
    }
    pokemon[slotIndex] = null;
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'pokemon': pokemon.map((p) => p?.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'id': id,
    };
  }

  // Create Team from JSON
  factory Team.fromJson(Map<String, dynamic> json) {
    final rawPokemon = json['pokemon'];
    List<Pokemon?> pokemonList = List.filled(6, null); // Start with 6 empty slots

    if (rawPokemon is List) {
      // Case 1: Stored as a proper list
      for (int i = 0; i < rawPokemon.length && i < 6; i++) {
        if (rawPokemon[i] != null) {
          pokemonList[i] = Pokemon.fromJson(Map<String, dynamic>.from(rawPokemon[i]));
        }
      }
    } else if (rawPokemon is Map) {
      // Case 2: Firebase stored as a map { "0": {...}, "1": {...} }
      rawPokemon.forEach((key, value) {
        int? index = int.tryParse(key.toString());
        if (index != null && index >= 0 && index < 6 && value != null) {
          pokemonList[index] = Pokemon.fromJson(Map<String, dynamic>.from(value));
        }
      });
    }

    return Team(
      name: json['name'] ?? '',
      pokemon: pokemonList, // Always exactly 6 items
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      id: json['id'],
    );
  }
}
