import '../models/card.dart';
import '../models/player.dart';
import '../utils/constants.dart';

class GameState {
  final List<Player> players;
  final int currentPlayerIndex;
  final int dealerIndex;
  final int leadPlayerIndex;
  final List<CardModel> currentTrick;
  final List<int> trickWinnerHistory;
  final GamePhase phase;
  final int roundNumber;
  final bool isRoundOver;
  final bool isGameOver;
  final int? winnerIndex;
  final int? aiThinkingForPlayer;

  GameState({
    required this.players,
    this.currentPlayerIndex = 0,
    this.dealerIndex = 0,
    this.leadPlayerIndex = 0,
    List<CardModel>? currentTrick,
    List<int>? trickWinnerHistory,
    this.phase = GamePhase.bidding,
    this.roundNumber = 1,
    this.isRoundOver = false,
    this.isGameOver = false,
    this.winnerIndex,
    this.aiThinkingForPlayer,
  })  : currentTrick = currentTrick ?? const [],
        trickWinnerHistory = trickWinnerHistory ?? const [];

  Player get currentPlayer => players[currentPlayerIndex];
  Player get leadPlayer => players[leadPlayerIndex];

  GameState copyWith({
    List<Player>? players,
    int? currentPlayerIndex,
    int? dealerIndex,
    int? leadPlayerIndex,
    List<CardModel>? currentTrick,
    List<int>? trickWinnerHistory,
    GamePhase? phase,
    int? roundNumber,
    bool? isRoundOver,
    bool? isGameOver,
    int? winnerIndex,
    int? aiThinkingForPlayer,
  }) {
    return GameState(
      players: players ?? this.players,
      currentPlayerIndex: currentPlayerIndex ?? this.currentPlayerIndex,
      dealerIndex: dealerIndex ?? this.dealerIndex,
      leadPlayerIndex: leadPlayerIndex ?? this.leadPlayerIndex,
      currentTrick: currentTrick ?? this.currentTrick,
      trickWinnerHistory: trickWinnerHistory ?? this.trickWinnerHistory,
      phase: phase ?? this.phase,
      roundNumber: roundNumber ?? this.roundNumber,
      isRoundOver: isRoundOver ?? this.isRoundOver,
      isGameOver: isGameOver ?? this.isGameOver,
      winnerIndex: winnerIndex ?? this.winnerIndex,
      aiThinkingForPlayer: aiThinkingForPlayer ?? this.aiThinkingForPlayer,
    );
  }
}
