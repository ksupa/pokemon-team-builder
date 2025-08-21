import 'package:flutter/material.dart';
import '../models/team.dart';

class PokemonSprites extends StatelessWidget {
  final Team team;

  const PokemonSprites({
    super.key,
    required this.team,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        children: List.generate(6, (index) {
          final pokemon = team.pokemon[index];
          return Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
              color: pokemon != null ? Colors.white : Colors.grey[100],
            ),
            child: pokemon != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                pokemon.sprite,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.help_outline,
                      size: 20, color: Colors.grey[400]);
                },
              ),
            )
                : Icon(Icons.add, size: 20, color: Colors.grey[400]),
          );
        }),
      ),
    );
  }
}
