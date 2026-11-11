library flutter_app_365.screens.score_screen;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../utils/constants.dart';

class ScoreScreen extends StatelessWidget {
  const ScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, child) {
        return Scaffold(
          backgroundColor: GameConstants.cardTableGreen,
          appBar: AppBar(
            title: const Text('Scoreboard'),
            backgroundColor: GameConstants.panelDark,
            iconTheme: const IconThemeData(color: Colors.white),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: game.scoreHistory.isEmpty
              ? const Center(
                  child: Text('No rounds played yet', style: TextStyle(color: Colors.white70)),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: game.scoreHistory.length,
                  itemBuilder: (context, index) {
                    final record = game.scoreHistory[index];
                    return Card(
                      color: GameConstants.panelDark.withValues(alpha: 0.8),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ExpansionTile(
                        title: Text('Round ${record.roundNumber}', style: const TextStyle(color: Colors.white)),
                        subtitle: Text('Totals: ${record.totalScores.join('  |  ')}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        children: List.generate(4, (i) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: GameConstants.accentCyan,
                              child: Text('P${i + 1}', style: const TextStyle(color: Colors.black, fontSize: 12)),
                            ),
                            title: Text(game.playerNames[i], style: const TextStyle(color: Colors.white)),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Round: ${record.roundScores[i]}', style: const TextStyle(color: GameConstants.textGold, fontSize: 12)),
                                Text('Total: ${record.totalScores[i]}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          );
                        }),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}


