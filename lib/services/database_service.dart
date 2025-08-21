// lib/services/database_service.dart
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/team.dart';

class DatabaseService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get _userId => _auth.currentUser?.uid;

  // Reference to user's teams in the database
  DatabaseReference get _userTeamsRef => _database.ref().child('users').child(_userId!).child('teams');

  // Save a team to Firebase
  Future<void> saveTeam(Team team) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    try {
      // Generate a unique ID for the team if it doesn't have one
      String teamId = team.id ?? _userTeamsRef.push().key!;

      // Create updated team with ID
      Team teamWithId = Team(
        name: team.name,
        pokemon: team.pokemon,
        createdAt: team.createdAt,
        id: teamId,
      );

      // Save to Firebase
      await _userTeamsRef.child(teamId).set(teamWithId.toJson());

      print('Team "${team.name}" saved successfully with ID: $teamId');
    } catch (e) {
      print('Error saving team: $e');
      throw Exception('Failed to save team: $e');
    }
  }

  // Load all teams for the current user
  Future<List<Team>> loadUserTeams() async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    try {
      final snapshot = await _userTeamsRef.get();

      if (!snapshot.exists) {
        return []; // No teams yet
      }

      List<Team> teams = [];
      Map<dynamic, dynamic> teamsData = snapshot.value as Map<dynamic, dynamic>;

      teamsData.forEach((key, value) {
        try {
          Map<String, dynamic> teamMap = _convertMap(value);
          teams.add(Team.fromJson(teamMap));
        } catch (e) {
          print('Error parsing team $key: $e');
        }
      });

      // Sort teams by creation date (newest first)
      teams.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return teams;
    } catch (e) {
      print('Error loading teams: $e');
      throw Exception('Failed to load teams: $e');
    }
  }

  // Delete a team
  Future<void> deleteTeam(String teamId) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    try {
      await _userTeamsRef.child(teamId).remove();
      print('Team deleted successfully');
    } catch (e) {
      print('Error deleting team: $e');
      throw Exception('Failed to delete team: $e');
    }
  }

  // Update an existing team
  Future<void> updateTeam(Team team) async {
    if (team.id == null) {
      throw Exception('Cannot update team without ID');
    }

    await saveTeam(team); // saveTeam handles both create and update
  }

  // Helper method to recursively convert Firebase maps
  Map<String, dynamic> _convertMap(dynamic data) {
    if (data is Map) {
      Map<String, dynamic> result = {};
      data.forEach((key, value) {
        String stringKey = key.toString();
        if (value is Map) {
          result[stringKey] = _convertMap(value);
        } else if (value is List) {
          result[stringKey] = _convertList(value);
        } else {
          result[stringKey] = value;
        }
      });
      return result;
    }
    return data;
  }

  // Helper method to convert Firebase lists
  List<dynamic> _convertList(List<dynamic> data) {
    return data.map((item) {
      if (item is Map) {
        return _convertMap(item);
      } else if (item is List) {
        return _convertList(item);
      } else {
        return item;
      }
    }).toList();
  }
}