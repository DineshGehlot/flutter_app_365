import 'package:flutter/material.dart';

class GameConstants {
  static const int winScore = 365;
  static const int cardsPerPlayer = 13;
  static const int totalCards = 52;
  static const int playerCount = 4;
  static const Suit trumpSuit = Suit.clubs;
  static const int minBid = 2;
  static const int maxBid = 13;
  static const int nillBid = 0;
  static const double cardWidth = 56.0;
  static const double cardHeight = 80.0;
  static const Color cardTableGreen = Color(0xFF1B5E20);
  static const Color panelDark = Color(0xFF212121);
  static const Color textGold = Color(0xFFFFD54F);
  static const Color textWhite = Colors.white;
  static const Color accentCyan = Color(0xFF00BCD4);
}

enum Suit { clubs, diamonds, hearts, spades }

extension SuitExtension on Suit {
  String get nameShort {
    switch (this) {
      case Suit.clubs: return 'C';
      case Suit.diamonds: return 'D';
      case Suit.hearts: return 'H';
      case Suit.spades: return 'S';
    }
  }
  String get nameFull {
    switch (this) {
      case Suit.clubs: return 'Clubs';
      case Suit.diamonds: return 'Diamonds';
      case Suit.hearts: return 'Hearts';
      case Suit.spades: return 'Spades';
    }
  }
  Color get color {
    switch (this) {
      case Suit.clubs: return Colors.black;
      case Suit.spades: return Colors.black;
      case Suit.hearts: return Colors.red;
      case Suit.diamonds: return Colors.red;
    }
  }
  IconData get icon {
    switch (this) {
      case Suit.clubs: return Icons.crop_square;
      case Suit.diamonds: return Icons.label;
      case Suit.hearts: return Icons.favorite;
      case Suit.spades: return Icons.spa;
    }
  }
}

enum GamePhase { bidding, playing, roundOver, gameOver }

class TrickResult {
  final int winningPlayerIndex;
  final int winningCardId;
  final List<int> cardsPlayed;
  final List<int> playerIndices;
  TrickResult({
    required this.winningPlayerIndex,
    required this.winningCardId,
    required this.cardsPlayed,
    required this.playerIndices,
  });
}

extension BuildContextX on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  double get safeTop => MediaQuery.of(this).padding.top;
  double get safeBottom => MediaQuery.of(this).padding.bottom;
  double get cardWidth => GameConstants.cardWidth;
  double get cardHeight => GameConstants.cardHeight;
}

extension IntX on int {
  Suit get toSuit {
    if (this <= 13) return Suit.clubs;
    if (this <= 26) return Suit.diamonds;
    if (this <= 39) return Suit.hearts;
    return Suit.spades;
  }
  int get toRank => ((this - 1) % 13) + 1;
  String get toCardName {
    final rank = toRank;
    final suit = toSuit;
    final rankName = switch (rank) {
      1 => '2', 2 => '3', 3 => '4', 4 => '5', 5 => '6', 6 => '7', 7 => '8',
      8 => '9', 9 => '10', 10 => 'J', 11 => 'Q', 12 => 'K', 13 => 'A',
      _ => '?',
    };
    return '$rankName${suit.nameShort}';
  }
  String get toAssetName => 'card_${this.toString().padLeft(2, '0')}.png';
}
