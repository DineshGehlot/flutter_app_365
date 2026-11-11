import 'package:flutter/material.dart';
import '../models/card.dart' as game_card;
import '../widgets/card_widget.dart';
import '../utils/constants.dart';

class TrickArea extends StatelessWidget {
  final List<game_card.CardModel> trick;

  const TrickArea({super.key, required this.trick});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Current Trick', style: TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 8),
        if (trick.isEmpty)
          Container(
            width: 48,
            height: 68,
            decoration: BoxDecoration(
              color: GameConstants.panelDark,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: GameConstants.accentCyan.withValues(alpha: 0.5)),
            ),
            child: const Center(child: Text('-', style: TextStyle(color: Colors.white70, fontSize: 32))),
          )
        else
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(trick.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: CardWidget(
                  card: trick[index],
                  faceUp: true,
                  width: 48,
                  height: 68,
                ),
              );
            }),
          ),
      ],
    );
  }
}
