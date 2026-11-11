import 'package:flutter/material.dart';
import '../models/card.dart' as game_card;
import '../utils/constants.dart';

class CardWidget extends StatelessWidget {
  final game_card.CardModel card;
  final bool faceUp;
  final bool isSelectable;
  final VoidCallback? onTap;
  final double width;
  final double height;

  const CardWidget({
    super.key,
    required this.card,
    this.faceUp = true,
    this.isSelectable = false,
    this.onTap,
    this.width = 56.0,
    this.height = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    final widget = faceUp ? _buildFaceUpCard() : _buildFaceDownCard();
    if (isSelectable && onTap != null) {
      return GestureDetector(onTap: onTap, child: widget);
    }
    return widget;
  }

  Widget _buildFaceUpCard() {
    final isRed = card.suit == Suit.hearts || card.suit == Suit.diamonds;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black, width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 4, offset: const Offset(2, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(card.name[0], style: TextStyle(fontWeight: FontWeight.bold, color: isRed ? Colors.red : Colors.black, fontSize: 14)),
                Text(card.suit.nameShort, style: TextStyle(fontWeight: FontWeight.bold, color: isRed ? Colors.red : Colors.black, fontSize: 14)),
              ],
            ),
          ),
          const Spacer(),
          Center(child: Icon(card.suit.icon, size: 32, color: isRed ? Colors.red : Colors.black)),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Transform.rotate(angle: 3.14159, child: Text(card.name[0], style: TextStyle(fontWeight: FontWeight.bold, color: isRed ? Colors.red : Colors.black, fontSize: 14))),
                Transform.rotate(angle: 3.14159, child: Text(card.suit.nameShort, style: TextStyle(fontWeight: FontWeight.bold, color: isRed ? Colors.red : Colors.black, fontSize: 14))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaceDownCard() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: GameConstants.panelDark,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: GameConstants.accentCyan, width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 4, offset: const Offset(2, 2))],
      ),
      child: const Center(child: Icon(Icons.card_travel, color: GameConstants.accentCyan, size: 40)),
    );
  }
}
