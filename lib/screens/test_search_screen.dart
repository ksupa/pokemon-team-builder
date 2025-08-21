import 'package:flutter/material.dart';
import 'package:pokemon_team_builder/services/api_service.dart';
import '../models/pokemon.dart';
import '../widgets/results_area.dart';
import '../models/team.dart';

class TestSearchScreen extends StatefulWidget {
  final int? slotIndex;        // null = regular search, number = team building
  final Team? currentTeam;     // current team state

  const TestSearchScreen({
    super.key,
    this.slotIndex,
    this.currentTeam,
  });

  @override
  State<TestSearchScreen> createState() => _TestSearchScreen();
}

class _TestSearchScreen extends State<TestSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();

  List<Pokemon> _searchResults = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool get _isTeamBuildingMode => widget.slotIndex != null;

  @override
  void initState() {
    super.initState();
    _loadFeaturedPokemon();
  }

  final List<String> _featurePokemon = [
    'pikachu', 'charizard', 'blastoise', 'venusaur', 'lucario',
    'garchomp', 'eevee', 'gengar', 'dragonite', 'mewtwo'
  ];

  Future<void> _loadFeaturedPokemon() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      List<Pokemon> featured = [];
      for(String name in _featurePokemon) {
        final pokemon = await _apiService.getPokemonByName(name);
        if(pokemon != null) {
          featured.add(pokemon);
        }
      }
      setState(() {
        _searchResults = featured;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load featured Pokemon';
        _isLoading = false;
      });
    }
  }

  Future<void> _searchPokemon() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await _apiService.searchPokemon(query);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Search Failed. Please try again.';
        _isLoading = false;
      });
    }
  }


 @override
 Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(_isTeamBuildingMode
          ? 'Choose Pokemon'
          : 'Search Pokemon'
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Search Bar
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search Pokemon',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                  onPressed: _isLoading ? null : _searchPokemon,
                  child: const Text('Search'),
              ),
            ]
          ),

          const SizedBox(height: 16),

          Expanded(
              child: ResultsArea(
                searchResults: _searchResults,
                isLoading: _isLoading,
                errorMessage: _errorMessage,
                isTeamBuildingMode: _isTeamBuildingMode,
                currentTeam: widget.currentTeam,
                onPokemonSelected: _onPokemonSelected,
              )
          )
        ],
      ),
    )
  );
 }
  void _onPokemonSelected(Pokemon pokemon) {
    if (_isTeamBuildingMode) {
      // Return the Pokemon to the team setup screen
      Navigator.pop(context, pokemon);
    } else {
      // Regular mode - just show a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added ${pokemon.name} to team!')),
      );
    }
  }
}