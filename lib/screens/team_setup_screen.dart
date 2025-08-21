import 'package:flutter/material.dart';
import 'package:pokemon_team_builder/screens/test_search_screen.dart';
import '../models/team.dart';
import '../models/pokemon.dart';
import '../services/database_service.dart';

class TeamSetupScreen extends StatefulWidget {
  final String teamName;
  final Team? existingTeam;

  const TeamSetupScreen({
    super.key,
    required this.teamName,
    this.existingTeam,
  });

  @override
  State<TeamSetupScreen> createState() => _TeamSetupScreenState();
}

class _TeamSetupScreenState extends State<TeamSetupScreen> {
  late Team currentTeam;
  final DatabaseService _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    // If editing existing team, load it. Otherwise create new empty team.
    if (widget.existingTeam != null) {
      currentTeam = Team(
        name: widget.existingTeam!.name,
        pokemon: List.from(widget.existingTeam!.pokemon), // Copy the list
        createdAt: widget.existingTeam!.createdAt,
        id: widget.existingTeam!.id,
      );
    } else {
      currentTeam = Team.empty(widget.teamName);
    }
  }

  void _onSlotTapped(int index) {
    // Only navigate if slot is empty
    if (currentTeam.pokemon[index] == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TestSearchScreen(
            slotIndex: index,
            currentTeam: currentTeam,
          ),
        ),
      ).then((selectedPokemon) {
        // Handle the returned Pokemon
        if (selectedPokemon != null && selectedPokemon is Pokemon) {
          setState(() {
            try {
              currentTeam.addPokemonToSlot(index, selectedPokemon);
            } catch (e) {
              // Show error if duplicate Pokemon
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(e.toString()),
                  backgroundColor: Colors.red,
                ),
              );
            }
          });
        }
      });
    }
  }

  void _removePokemon(int index) {
    final pokemon = currentTeam.pokemon[index]!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Pokemon'),
          content: Text('Are you sure you want to remove ${pokemon.name.toUpperCase()} from your team?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  currentTeam.removePokemonFromSlot(index);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Remove', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _saveTeam() async {
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Save to Firebase
      await _databaseService.saveTeam(currentTeam);

      // Hide loading
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Team "${currentTeam.name}" saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Go back to dashboard
      Navigator.of(context).pop();

    } catch (e) {
      // Hide loading
      Navigator.of(context).pop();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save team: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.teamName),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return _buildTeamSlot(index);
                },
              ),
            ),

            // Save button - only show when team has Pokemon
            if (currentTeam.pokemonCount > 0)
              SizedBox(
                width: double.infinity, // Full width button
                child: ElevatedButton(
                  onPressed: _saveTeam,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: Text('Save Team (${currentTeam.pokemonCount}/6)'),
                ),
              ),
          ],
        )
      )
    );
  }

  Widget _buildTeamSlot(int index) {
    final pokemon = currentTeam.pokemon[index];
    final bool isEmpty = pokemon == null;

    return GestureDetector(
      onTap: () => _onSlotTapped(index),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[400]!, width: 2),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[50],
        ),
        child: isEmpty ? _buildEmptySlot(index) : _buildFilledSlot(pokemon!, index),
      ),
    );
  }

  Widget _buildEmptySlot(int index) {
    return Center(
      child: Text(
        'Slot ${index + 1}',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[600],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildFilledSlot(Pokemon pokemon, int index) {
    return Stack(
      children: [
        // Pokemon content
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pokemon image
              Expanded(
                flex: 3,
                child: Image.network(
                  pokemon.sprite,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image_not_supported, size: 40);
                  },
                ),
              ),

              const SizedBox(height: 4),

              // Pokemon name
              Expanded(
                flex: 1,
                child: Text(
                  pokemon.name.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        // Remove button (X) in top right
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _removePokemon(index),
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}