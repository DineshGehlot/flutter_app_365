import 'package:flutter/material.dart';
import '../models/player.dart';
import '../widgets/card_widget.dart';
import '../utils/constants.dart';

enum PlayerPosition { top, bottom, left, right }

class PlayerZone extends StatelessWidget {
  final Player player;
  final PlayerPosition position;
  final bool currentPlayer;
  final GamePhase phase;
  final void Function(int cardIndex)? onCardTap;

  const PlayerZone({
    super.key,
    required this.player,
    required this.position,
    required this.currentPlayer,
    required this.phase,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    switch (position) {
      case PlayerPosition.bottom: return _buildBottomZone(context);
      case PlayerPosition.top: return _buildTopZone();
      case PlayerPosition.left: return _buildSideZone(isLeft: true);
      case PlayerPosition.right: return _buildSideZone(isLeft: false);
    }
  }

  Widget _buildBottomZone(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(player.name, style: TextStyle(color: currentPlayer ? GameConstants.accentCyan : Colors.white, fontWeight: FontWeight.bold)),
          if (player.bid != 0 && phase == GamePhase.bidding)
            Container(margin: const EdgeInsets.only(left: 8), padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: GameConstants.textGold.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4), border: Border.all(color: GameConstants.textGold)), child: Text(player.bid == 0 ? 'Nill' : player.bid.toString(), style: const TextStyle(color: GameConstants.textGold, fontWeight: FontWeight.bold, fontSize: 12))),
          if (phase == GamePhase.playing && player.bid != 0)
            Text('Bid: ${player.bid}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
          if (phase == GamePhase.roundOver || phase == GamePhase.gameOver)
            Text('${player.handsWon} hands', style: const TextStyle(color: GameConstants.textGold, fontSize: 12)),
        ]),
        const SizedBox(height: 8),
        // Show cards in rows using Wrap so all 13 cards are visible without scrolling
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 4,
          runSpacing: 6,
          children: List.generate(player.hand.length, (index) {
            final card = player.hand[index];
            final isMyTurn = currentPlayer && phase == GamePhase.playing;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: CardWidget(
                card: card,
                faceUp: true,
                width: 42,
                height: 60,
                isSelectable: isMyTurn,
                onTap: isMyTurn ? () => onCardTap!(index) : null,
              ),
            );
          }),
        ),
        if (player.handsWon > 0 || phase != GamePhase.playing)
          Text('${player.handsWon} hands', style: const TextStyle(color: GameConstants.textGold, fontSize: 12)),
      ],
    );
  }

  Widget _buildTopZone() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(player.name, style: const TextStyle(color: Colors.white70)),
          if (player.bid != 0 && phase == GamePhase.bidding)
            Text('Bid: ${player.bid == 0 ? 'Nill' : player.bid}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
          if (phase == GamePhase.roundOver || phase == GamePhase.gameOver)
            Text('${player.handsWon} hands', style: const TextStyle(color: GameConstants.textGold, fontSize: 12)),
        ]),
        const SizedBox(height: 8),
        SizedBox(
          height: 88,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: player.hand.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: CardWidget(card: player.hand[index], faceUp: false),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSideZone({required bool isLeft}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(player.name, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 8),
        // Show cards in rows using Wrap so all 13 cards are visible without scrolling
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 4,
          runSpacing: 6,
          children: List.generate(player.hand.length, (index) {
            final card = player.hand[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: CardWidget(
                card: card,
                faceUp: false,
                width: 42,
                height: 60,
              ),
            );
          }),
        ),
        if (player.bid != 0)
          Text('Bid: ${player.bid == 0 ? 'Nill' : player.bid}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
        if (phase == GamePhase.roundOver || phase == GamePhase.gameOver)
          Text('${player.handsWon} hands', style: const TextStyle(color: GameConstants.textGold, fontSize: 12)),
      ],
    );
  }
}
