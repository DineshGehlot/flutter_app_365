import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/player_zone.dart';
import '../widgets/trick_area.dart';
import '../widgets/bid_dialog.dart';
import '../utils/constants.dart';
import '../models/player.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GameProvider>().startNewRound();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, child) {
        if (game.state.isGameOver) {
          return _buildGameOverScreen(context, game);
        }
        if (game.state.phase == GamePhase.roundOver) {
          return _buildRoundOverScreen(context, game);
        }
        return Scaffold(
          body: Container(
            color: GameConstants.cardTableGreen,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildTopBar(game),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          PlayerZone(
                            player: game.state.players[2],
                            position: PlayerPosition.top,
                            currentPlayer: game.state.currentPlayerIndex == 2,
                            phase: game.state.phase,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(child: PlayerZone(
                                player: game.state.players[3],
                                position: PlayerPosition.right,
                                currentPlayer: game.state.currentPlayerIndex == 3,
                                phase: game.state.phase,
                              )),
                              const SizedBox(width: 12),
                              TrickArea(trick: game.state.currentTrick),
                              const SizedBox(width: 12),
                              Expanded(child: PlayerZone(
                                player: game.state.players[1],
                                position: PlayerPosition.left,
                                currentPlayer: game.state.currentPlayerIndex == 1,
                                phase: game.state.phase,
                              )),
                            ],
                          ),
                          const SizedBox(height: 8),
                          PlayerZone(
                            player: game.state.players[0],
                            position: PlayerPosition.bottom,
                            currentPlayer: game.state.currentPlayerIndex == 0,
                            phase: game.state.phase,
                            onCardTap: (cardIndex) => game.playCard(cardIndex),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: game.state.phase == GamePhase.bidding && game.state.currentPlayerIndex == 0
              ? FloatingActionButton.extended(
                  onPressed: () => _showBidDialog(context, game),
                  icon: const Icon(Icons.add),
                  label: const Text('Place Bid'),
                  backgroundColor: GameConstants.accentCyan,
                )
              : null,
        );
      },
    );
  }

  Widget _buildTopBar(GameProvider game) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: GameConstants.panelDark.withValues(alpha: 0.8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Round ${game.state.roundNumber}', style: const TextStyle(color: Colors.white70, fontSize: 16)),
          Row(mainAxisSize: MainAxisSize.min, children: List.generate(4, (i) => _scoreBadge(game.state.players[i], game, i))),
          IconButton(icon: const Icon(Icons.menu, color: Colors.white70), onPressed: () => _showMenu(context, game)),
        ],
      ),
    );
  }

  Widget _scoreBadge(Player player, GameProvider game, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: game.state.currentPlayerIndex == index
            ? GameConstants.accentCyan.withValues(alpha: 0.3)
            : Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: game.state.currentPlayerIndex == index ? GameConstants.accentCyan : Colors.transparent,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(player.name, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          Text('${player.totalScore}', style: TextStyle(color: GameConstants.textGold, fontSize: 14, fontWeight: FontWeight.bold)),
          if (game.state.phase == GamePhase.bidding && player.bid != 0)
            Text("Bid: ${player.bid == GameConstants.nillBid ? 'Nill' : player.bid}", style: const TextStyle(color: Colors.white70, fontSize: 10)),
        ],
      ),
    );
  }

  void _showBidDialog(BuildContext context, GameProvider game) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => BidDialog(
        currentBid: game.state.currentPlayer.bid,
        onBidSelected: (bid) {
          Navigator.of(context).pop();
          game.setBid(0, bid);
        },
      ),
    );
  }

  void _showMenu(BuildContext context, GameProvider game) {
    showModalBottomSheet(
      context: context,
      backgroundColor: GameConstants.panelDark,
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Game Menu', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ListTile(leading: const Icon(Icons.refresh, color: Colors.white70), title: const Text('New Round', style: TextStyle(color: Colors.white)), onTap: () { Navigator.pop(context); game.resetGame(); game.startNewRound(); }),
            ListTile(leading: const Icon(Icons.scoreboard, color: Colors.white70), title: const Text('Scoreboard', style: TextStyle(color: Colors.white)), onTap: () { Navigator.pop(context); Navigator.of(context).pushNamed('/score'); }),
            ListTile(leading: const Icon(Icons.help, color: Colors.white70), title: const Text('Rules', style: TextStyle(color: Colors.white)), onTap: () { Navigator.pop(context); Navigator.of(context).pushNamed('/rules'); }),
            ListTile(leading: const Icon(Icons.exit_to_app, color: Colors.white70), title: const Text('Main Menu', style: TextStyle(color: Colors.white)), onTap: () { Navigator.pop(context); Navigator.of(context).pushReplacementNamed('/home'); }),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundOverScreen(BuildContext context, GameProvider game) {
    return Scaffold(
      body: Container(
        color: GameConstants.cardTableGreen,
        child: Center(
          child: Card(
            color: GameConstants.panelDark,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Round Over', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  ...List.generate(4, (i) {
                    final p = game.state.players[i];
                    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(p.name, style: const TextStyle(color: Colors.white70)),
                      Text("Bid: ${p.bid == 0 ? 'Nill' : p.bid}", style: const TextStyle(color: Colors.white70)),
                      Text('Hands: ${p.handsWon}', style: const TextStyle(color: Colors.white70)),
                      Text('${p.roundScore}', style: TextStyle(color: GameConstants.textGold, fontWeight: FontWeight.bold)),
                    ]);
                  }),
                  const SizedBox(height: 20),
                  Text('Totals: ${game.state.players.map((p) => p.totalScore).join(String.fromCharCode(124))}', style: const TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(height: 24),
                  SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => game.startNextRound(), child: const Text('Next Round'))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameOverScreen(BuildContext context, GameProvider game) {
    return Scaffold(
      body: Container(
        color: GameConstants.cardTableGreen,
        child: Center(
          child: Card(
            color: GameConstants.panelDark,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('\u{1F3C6} Game Over!', style: TextStyle(color: GameConstants.textGold, fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Text('${game.state.players[game.state.winnerIndex!].name} Wins!', style: const TextStyle(color: Colors.white, fontSize: 24)),
                  const SizedBox(height: 24),
                  ...List.generate(4, (i) {
                    final p = game.state.players[i];
                    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(p.name, style: const TextStyle(color: Colors.white70)),
                      Text('${p.totalScore}', style: TextStyle(color: GameConstants.textGold, fontWeight: FontWeight.bold)),
                    ]);
                  }),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(child: OutlinedButton(onPressed: () { game.resetGame(); game.startNewRound(); }, child: const Text('Play Again'))),
                      const SizedBox(width: 12),
                      Expanded(child: ElevatedButton(onPressed: () => Navigator.of(context).pushReplacementNamed('/home'), child: const Text('Main Menu'))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



