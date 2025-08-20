import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class ApiService {
  static const String _baseUrl = 'https://pokeapi.co/api/v2/';

  Future<List<Pokemon>> searchPokemon(String query) async {
    if(query.isEmpty) return [];

    try {
      // Get all Pokemon
      final pokemonNames = await _getAllPokemonNames();

      // Filter the pokemon based on search
      final filteredNames = _filterPokemonNames(pokemonNames, query);

      // Get info for each match
      final pokemonList = await _getPokemonDetails(filteredNames);

      // Return filtered names
      return pokemonList;
    } catch (e) {
      // TODO: Show error message to user (SnackBar/Toast message)
      print('Search error: $e'); // To the console for debugging

      // UI shows "no results"
      return [];
    }
  }

  Future<List<String>> _getAllPokemonNames() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/pokemon?limit=1000'));

      if(response.statusCode == 200) {
        final data = json.decode(response.body);

        List<String> pokemonNames = [];
        for(var nameData in data['results']) {
          pokemonNames.add(nameData['name']);
        }

        return pokemonNames;

      } else {
        throw Exception('Failed to get Pokemon Names');
      }
    } catch (e) {
      throw Exception('Error fetching Pokemon: $e');
    }
  }

  Future<List<Pokemon>> _getPokemonDetails(List<String> filteredNames) async {
    List<Pokemon> pokemonList = [];
    for(String name in filteredNames) {
      try {
        final response = await http.get(Uri.parse('$_baseUrl/pokemon/$name'));

        if(response.statusCode == 200) {
          final data = json.decode(response.body);
          final pokemon = Pokemon.fromJson(data);
          pokemonList.add(pokemon);
        }
      } catch (e) {
        print('Error loading $name: $e');
      }
    }

    return pokemonList;
  }

  List<String> _filterPokemonNames(List<String> allNames, String query) {
    String lowerCaseQuery = query.toLowerCase();

    List<String> startsWith = [];
    List<String> contains = [];

    // Checks if the name starts with the query
    for(String name in allNames) {
      if(name.toLowerCase().startsWith(lowerCaseQuery)) {
        startsWith.add(name);
      } else if(name.toLowerCase().contains(lowerCaseQuery)) {
        contains.add(name);
      }
    }
    return startsWith + contains;
  }


}