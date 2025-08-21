import 'package:flutter/material.dart';
// Models
import '../models/team.dart';

// Services
import '../services/auth_service.dart';
import '../services/database_service.dart';

// Screens
import 'team_setup_screen.dart';
import 'login_screen.dart';

// Widgets
import '../widgets/empty_state.dart';
import '../widgets/team_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AuthService _authService = AuthService();
  List<Team> _teams = [];
  bool _isLoading = false;
  final DatabaseService _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _loadTeams();
  }

  Future<void> _loadTeams() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final teams = await _databaseService.loadUserTeams();
      setState(() {
        _teams = teams;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load teams: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showCreateTeamDialog() {
    final TextEditingController teamNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create New Team'),
          content: TextField(
            controller: teamNameController,
            decoration: const InputDecoration(
              labelText: 'Team Name',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final teamName = teamNameController.text.trim();
                if (teamName.isNotEmpty) {
                  Navigator.of(context).pop();
                  _createNewTeam(teamName);
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _createNewTeam(String teamName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamSetupScreen(teamName: teamName),
      ),
    ).then((_) {
      // Refresh teams when returning from team setup
      _loadTeams();
    });
  }

  void _openTeam(Team team) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamSetupScreen(
          teamName: team.name,
          existingTeam: team, // Pass the existing team
        ),
      ),
    ).then((_) => _loadTeams());
  }

  void _logout() async {
    await _authService.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokemon Team Builder'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _teams.isEmpty
          ? _buildEmptyState()
          : _buildTeamsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateTeamDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return EmptyState(
      onCreateTeam: _showCreateTeamDialog,
    );
  }

  Widget _buildTeamsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _teams.length,
      itemBuilder: (context, index) {
        return TeamCard(
          team: _teams[index],
          onTap: () => _openTeam(_teams[index]),
        );
      },
    );
  }
}