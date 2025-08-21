import 'package:flutter/material.dart';
import 'team_card.dart';
import '../models/team.dart';

class TeamsList extends StatelessWidget {
  final List<Team> teams;
  final Function(Team) onTeamTap;

  const TeamsList({
    super.key,
    required this.teams,
    required this.onTeamTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: teams.length,
      itemBuilder: (context, index) {
        return TeamCard(
          team: teams[index],
          onTap: () => onTeamTap(teams[index]),
        );
      },
    );
  }
}
