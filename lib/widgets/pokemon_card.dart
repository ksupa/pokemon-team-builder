import 'package:flutter/material.dart';
import '../models/pokemon.dart';

class PokemonCard extends StatelessWidget {
 final Pokemon pokemon;

 const PokemonCard({super.key, required this.pokemon});

 Color _getTypeColor(String type) {
   switch (type.toLowerCase()) {
     case 'fire':
       return Colors.red;
     case 'water':
       return Colors.blue;
     case 'grass':
       return Colors.green;
     case 'electric':
       return Colors.yellow[700]!;
     case 'psychic':
       return Colors.purple;
     case 'ice':
       return Colors.lightBlue;
     case 'dragon':
       return Colors.indigo;
     case 'fairy':
       return Colors.pink;
     case 'fighting':
       return Colors.brown;
     case 'poison':
       return Colors.deepPurple;
     case 'ground':
       return Colors.orange[800]!;
     case 'flying':
       return Colors.blue[300]!;
     case 'bug':
       return Colors.lightGreen;
     case 'rock':
       return Colors.grey[600]!;
     case 'ghost':
       return Colors.deepPurple[300]!;
     case 'steel':
       return Colors.blueGrey;
     case 'dark':
       return Colors.grey[800]!;
     default:
       return Colors.grey;
   }
 }

 Widget _buildTypeChip(String type) {
   return Container(
     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
     decoration: BoxDecoration(
       color: Colors.white,
       border: Border.all(color: _getTypeColor(type), width: 2),
       borderRadius: BorderRadius.circular(16),
     ),
     child: Text(
       type.toUpperCase(),
       style: TextStyle(
         color: _getTypeColor(type),
         fontSize: 12,
         fontWeight: FontWeight.bold,
       )
     )
   );
 }

 @override
  Widget build(BuildContext context) {
   return Card(
     margin: const EdgeInsets.only(bottom: 12),
     child: Column(
       crossAxisAlignment: CrossAxisAlignment.center,
       children: [
         // Pokemon sprite
         Image.network(
           pokemon.sprite,
           height: 100,
           width: 100,
           errorBuilder: (context, error, stackTrace) {
             return const Icon(Icons.image_not_supported, size: 100);
           },
         ),

         const SizedBox(height: 12),

         // Pokemon name
         Text(
           pokemon.name.toUpperCase(),
           style: const TextStyle(
             fontSize: 18,
             fontWeight: FontWeight.bold,
           ),
         ),

         const SizedBox(height: 8),

         // Pokemon types with colors
         Wrap(
           spacing: 8,
           children: pokemon.types.map((type) => _buildTypeChip(type)).toList(),
         ),
       ]
     )
   );
  }
}