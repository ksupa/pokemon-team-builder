import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import 'pokemon_card.dart';

class ResultsArea extends StatelessWidget {
  final List<Pokemon> searchResults;
  final bool isLoading;
  final String? errorMessage;

  const ResultsArea({
    super.key,
    required this.searchResults,
    required this.isLoading,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Text(
          errorMessage!,
          style: const TextStyle(
              color: Colors.red,
              fontSize: 16,
          ),
        )
      );
    }

    if (searchResults.isEmpty) {
      return const Center(
        child: Text(
          'No Pokemon found. Try a new search.',
          style: TextStyle(fontSize: 16),
        )
      );
    }

    return ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          return PokemonCard(pokemon: searchResults[index]);
      },
    );
  }
}