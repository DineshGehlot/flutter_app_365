library flutter_app_365.screens.rules_screen;

import 'package:flutter/material.dart';
import '../utils/constants.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GameConstants.cardTableGreen,
      appBar: AppBar(
        title: const Text('Game Rules'),
        backgroundColor: GameConstants.panelDark,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('365 Card Game', style: TextStyle(color: GameConstants.textGold, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildSection('Overview', [
              'Four players play clockwise.',
              'A standard 52-card pack is used.',
              'Clubs is the fixed trump suit.',
              'Card rank within each suit: A K Q J 10 9 8 7 6 5 4 3 2.',
            ]),
            const SizedBox(height: 16),
            _buildSection('Bidding', [
              'A bid specifies how many tricks (hands) the player can win.',
              'Bid may be Nill (0) or a number between 2 and 13.',
              'Every player tries to win at least their bid number of hands.',
            ]),
            const SizedBox(height: 16),
            _buildSection('Scoring', [
              'Exact bid made: Bid × 10 points.',
              'Nill with 0 hands: +99 points.',
              'Nill with 1+ hands: -99 points.',
              'Less than bid: -Bid × 10 points.',
              '1 or 2 over bid: Bid × 10 + number of overtricks.',
              '3 or more over bid: -Bid × 10 points.',
            ]),
            const SizedBox(height: 16),
            _buildSection('Playing Rules', [
              'The first trick is led by the player who bid Nill or the highest bidder.',
              'The suit of the first card played is the face suit.',
              'Players must follow suit if possible.',
              'Highest card in the face suit wins, unless trumped.',
              'Clubs (trump) beat non-trump cards.',
              'The winner of each trick leads the next.',
            ]),
            const SizedBox(height: 16),
            _buildSection('Winning', [
              'First player to accumulate 365 points wins the game.',
            ]),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Got It'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• ', style: TextStyle(color: GameConstants.accentCyan)),
              Expanded(child: Text(item, style: const TextStyle(color: Colors.white70, height: 1.4))),
            ],
          ),
        )),
      ],
    );
  }
}
