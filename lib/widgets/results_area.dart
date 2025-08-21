import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import 'pokemon_card.dart';
import '../models/team.dart';

class ResultsArea extends StatelessWidget {
  final List<Pokemon> searchResults;
  final bool isLoading;
  final String? errorMessage;
  final bool isTeamBuildingMode;
  final Team? currentTeam;
  final Function(Pokemon)? onPokemonSelected;

  const ResultsArea({
    super.key,
    required this.searchResults,
    required this.isLoading,
    this.errorMessage,
    this.isTeamBuildingMode = false,
    this.currentTeam,
    this.onPokemonSelected,
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
          final pokemon = searchResults[index];

          // Check if Pokemon is already in team (for team building mode)
          final isAlreadyInTeam = isTeamBuildingMode &&
            currentTeam != null &&
            currentTeam!.containsPokemon(pokemon);

          return PokemonCard(
            pokemon: pokemon,
            isTeamBuildingMode: isTeamBuildingMode,
            isAlreadyInTeam: isAlreadyInTeam,
            onAddToTeam: isAlreadyInTeam ? null : () {
              onPokemonSelected?.call(pokemon);
            },
          );
        },
    );
  }
}