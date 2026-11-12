import 'package:flutter/foundation.dart';
import '../models/card.dart';
import '../models/game_state.dart';
import '../models/player.dart';
import '../models/score_record.dart';
import '../services/ai_service.dart';
import '../services/deck_service.dart';
import '../services/scoring_service.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';
import 'dart:async';

class GameProvider extends ChangeNotifier {
  GameState _state = GameState(players: List.generate(4, (i) => Player(index: i, name: 'Player ${i + 1}')));
  final List<ScoreRecord> _scoreHistory = [];
  List<String> _playerNames = ['Player 1', 'Player 2', 'Player 3', 'Player 4'];
  Timer? _aiTimer;

  GameState get state => _state;
  List<ScoreRecord> get scoreHistory => List.unmodifiable(_scoreHistory);
  List<String> get playerNames => List.unmodifiable(_playerNames);
  bool get isAITurn => !_state.currentPlayer.isHuman && _state.phase == GamePhase.playing && !_state.isRoundOver;

  Future<void> init() async {
    await StorageService.init();
    _playerNames = await StorageService.getPlayerNames();
    final players = <Player>[];
    for (var i = 0; i < 4; i++) {
      players.add(Player(index: i, name: _playerNames[i]));
    }
    final scores = await StorageService.getTotalScores();
    for (var i = 0; i < 4 && i < scores.length; i++) {
      players[i].totalScore = scores[i];
    }
    _state = GameState(players: players, roundNumber: await StorageService.getRoundNumber());
    notifyListeners();
  }

  void setPlayerNames(List<String> names) {
    _playerNames = names;
    _state = GameState(players: List.generate(4, (i) => Player(index: i, name: names[i], isHuman: i == 0)));
    _scoreHistory.clear();
    notifyListeners();
  }

  void startNewRound() {
    final deck = DeckService.shuffle(DeckService.createDeck());
    final players = List.of(_state.players);
    for (var p in players) p.clearHand();
    DeckService.deal(deck, players);

    _state = _state.copyWith(
      players: players,
      currentTrick: const [],
      trickWinnerHistory: const [],
      phase: GamePhase.bidding,
      leadPlayerIndex: (_state.leadPlayerIndex + 1) % 4,
      currentPlayerIndex: (_state.leadPlayerIndex + 1) % 4,
      isRoundOver: false,
      aiThinkingForPlayer: null,
    );
    notifyListeners();
    _resolveAIBid();
  }

  void setBid(int playerIndex, int bid) {
    final players = List.of(_state.players);
    final p = players[playerIndex];
    p.bid = bid;
    _state = _state.copyWith(players: players);
    final allBid = players.every((p) => p.bid != 0);
    if (allBid) {
      _state = _state.copyWith(phase: GamePhase.playing, currentPlayerIndex: _state.leadPlayerIndex);
      // If lead player is AI, schedule it to play the first card
      if (!_state.players[_state.leadPlayerIndex].isHuman) {
        _scheduleAIPlay(_state.leadPlayerIndex);
      }
    } else {
      final next = (playerIndex + 1) % 4;
      _state = _state.copyWith(currentPlayerIndex: next);
      _resolveAIBid();
    }
    notifyListeners();
  }

  void playCard(int cardIndex) {
    if (_state.phase != GamePhase.playing || _state.isRoundOver) return;
    if (_state.currentPlayer.isHuman == false) return;

    final card = _state.currentPlayer.playCard(cardIndex);
    if (card == null) return;
    _playCardInternal(card);
  }

  Future<void> _playCardInternal(CardModel card) async {
    final trick = List<CardModel>.from(_state.currentTrick)..add(card);
    final playerIndex = _state.currentPlayerIndex;
    _state = _state.copyWith(
      currentTrick: trick,
      currentPlayerIndex: (playerIndex + 1) % 4,
    );
    notifyListeners();

    if (trick.length == 4) {
      await _resolveTrick();
    } else {
      final next = _state.currentPlayerIndex;
      if (!_state.players[next].isHuman) {
        _scheduleAIPlay(next);
      }
      notifyListeners();
    }
  }

  void _resolveAIBid() {
    final current = _state.currentPlayerIndex;
    if (!_state.players[current].isHuman && _state.phase == GamePhase.bidding) {
      _aiTimer?.cancel();
      _aiTimer = Timer(const Duration(milliseconds: 1200), () {
        if (_state.phase != GamePhase.bidding) return;
        final bid = AIService.calculateBid(_state.players[current]);
        setBid(current, bid);
      });
    }
  }

  void _scheduleAIPlay(int playerIndex) {
    _aiTimer?.cancel();
    _aiTimer = Timer(const Duration(milliseconds: 1500), () {
      if (_state.phase != GamePhase.playing || _state.isRoundOver) return;
      if (_state.currentPlayerIndex != playerIndex) return;

      final faceSuit = _state.currentTrick.isNotEmpty
          ? _state.currentTrick.first.suit
          : Suit.clubs;
      final isNill = _state.players[playerIndex].bid == 0;

      final cardIndex = AIService.selectCardIndex(
        _state.players[playerIndex],
        faceSuit,
        _state.currentTrick,
        isNill: isNill,
      );

      if (cardIndex >= 0) {
        final card = _state.players[playerIndex].playCard(cardIndex);
        if (card != null) {
          _playCardInternal(card);
        }
      }
    });
  }

  Future<void> _resolveTrick() async {
    final trick = _state.currentTrick;
    if (trick.isEmpty) return;
    final faceSuit = trick.first.suit;

    int winningPos = 0;
    CardModel winningCard = trick[0];
    for (var i = 1; i < 4; i++) {
      if (trick[i].compareTo(winningCard, faceSuit) > 0) {
        winningCard = trick[i];
        winningPos = i;
      }
    }

    final startPlayer = _state.leadPlayerIndex;
    final winningPlayerIndex = (startPlayer + winningPos) % 4;

    final players = List.of(_state.players);
    final winner = players[winningPlayerIndex];
    winner.handsWon = winner.handsWon + 1;

    _state = _state.copyWith(
      players: players,
      currentTrick: const [],
      trickWinnerHistory: List.of(_state.trickWinnerHistory)..add(winningPlayerIndex),
      leadPlayerIndex: winningPlayerIndex,
      currentPlayerIndex: winningPlayerIndex,
    );

    final allEmpty = players.every((p) => p.hand.isEmpty);
    if (allEmpty) {
      _endRound();
    } else {
      notifyListeners();
      if (!_state.players[_state.currentPlayerIndex].isHuman) {
        _scheduleAIPlay(_state.currentPlayerIndex);
      }
    }
  }

  Future<void> _endRound() async {
    final roundScores = <int>[];
    for (var i = 0; i < 4; i++) {
      final p = _state.players[i];
      final score = calculateRoundScore(p.bid, p.handsWon, p.bid == 0);
      p.roundScore = score;
      p.totalScore = p.totalScore + score;
      roundScores.add(score);
    }
    final totalScores = _state.players.map((p) => p.totalScore).toList();
    _scoreHistory.add(ScoreRecord(
      roundNumber: _state.roundNumber,
      roundScores: roundScores,
      totalScores: totalScores,
    ));
    final winner = checkWinner(totalScores);
    _state = _state.copyWith(
      phase: GamePhase.roundOver,
      isRoundOver: true,
      winnerIndex: winner,
    );
    await StorageService.saveTotalScores(totalScores);
    await StorageService.saveRoundNumber(_state.roundNumber + 1);
    if (winner != null) {
      _state = _state.copyWith(phase: GamePhase.gameOver, isGameOver: true);
    }
    _aiTimer?.cancel();
    notifyListeners();
  }

  void startNextRound() {
    _state = _state.copyWith(
      phase: GamePhase.bidding,
      isRoundOver: false,
      roundNumber: _state.roundNumber + 1,
      winnerIndex: null,
      aiThinkingForPlayer: null,
    );
    startNewRound();
  }

  void resetGame() {
    _state = GameState(players: List.generate(4, (i) => Player(index: i, name: _playerNames[i], isHuman: i == 0)));
    _scoreHistory.clear();
    StorageService.resetGame();
    notifyListeners();
  }

  @override
  void dispose() {
    _aiTimer?.cancel();
    super.dispose();
  }
}

