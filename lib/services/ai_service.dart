import '../models/card.dart';
import '../models/player.dart';
import '../utils/constants.dart';
import 'dart:math';

class AIService {
  static final Random _random = Random();

  static int calculateBid(Player player) {
    final hand = player.hand;
    int bid = 0;
    int colourCount = 0;

    for (final card in hand) {
      if (card.id > 39) {
        bid += 1;
        colourCount += 1;
      }
    }

    if (colourCount > 3) {
      bid += (colourCount - 3);
    }

    if (bid == 0) {
      int q = 0;
      for (final card in hand) {
        if (card.id == 11 || card.id == 24 || card.id == 37) q += 1;
        if (card.id == 13 || card.id == 26 || card.id == 39 || card.id == 52 ||
            card.id == 50 || card.id == 49 || card.id == 48) q += 1;
        else if (card.id == 12 || card.id == 25 || card.id == 38 || card.id == 51) q += 1;
      }
      if (q != 0) bid = 2;
    }

    if (bid < GameConstants.minBid) bid = GameConstants.minBid;
    if (bid > GameConstants.maxBid) bid = GameConstants.maxBid;

    return bid;
  }

  static int selectCardIndex(Player player, Suit faceSuit, List<CardModel> trickCards,
      {bool isNill = false}) {
    final hand = player.hand;
    if (hand.isEmpty) return -1;

    final sameSuitIndices = hand
        .asMap()
        .entries
        .where((e) => e.value.suit == faceSuit)
        .map((e) => e.key)
        .toList();

    if (sameSuitIndices.isNotEmpty) {
      if (trickCards.isNotEmpty) {
        final highestOnTable = trickCards.reduce((a, b) =>
            a.rank > b.rank ? a : b);
        final higherCards = sameSuitIndices
            .where((i) => hand[i].rank > highestOnTable.rank)
            .toList();

        if (higherCards.isNotEmpty) {
          return higherCards[_random.nextInt(higherCards.length)];
        }
        final lowestOfSuit = sameSuitIndices.reduce((a, b) =>
            hand[a].rank < hand[b].rank ? a : b);
        return lowestOfSuit;
      }
      return sameSuitIndices[_random.nextInt(sameSuitIndices.length)];
    }

    if (isNill) {
      return _selectNillCard(hand, faceSuit, trickCards);
    }

    final trumpIndices = hand
        .asMap()
        .entries
        .where((e) => e.value.suit == Suit.clubs)
        .map((e) => e.key)
        .toList();

    if (trumpIndices.isNotEmpty) {
      if (trickCards.isNotEmpty) {
        final highestTrumpOnTable = trickCards
            .where((c) => c.suit == Suit.clubs)
            .fold<CardModel?>(null, (prev, c) => prev == null || c.rank > prev.rank ? c : prev);
        if (highestTrumpOnTable != null) {
          final higherTrumps = trumpIndices
              .where((i) => hand[i].rank > highestTrumpOnTable.rank)
              .toList();
          if (higherTrumps.isNotEmpty) {
            return higherTrumps[_random.nextInt(higherTrumps.length)];
          }
        }
      }
      return trumpIndices[_random.nextInt(trumpIndices.length)];
    }

    return _random.nextInt(hand.length);
  }

  static int _selectNillCard(List<CardModel> hand, Suit faceSuit, List<CardModel> trickCards) {
    if (trickCards.isNotEmpty) {
      final highestOnTable = trickCards.reduce((a, b) => a.rank > b.rank ? a : b);
      final safeCards = hand
          .asMap()
          .entries
          .where((e) => e.value.rank <= highestOnTable.rank)
          .map((e) => e.key)
          .toList();
      if (safeCards.isNotEmpty) {
        return safeCards[_random.nextInt(safeCards.length)];
      }
      return hand.asMap().entries.reduce((a, b) => a.value.rank < b.value.rank ? a : b).key;
    }
    return hand.asMap().entries.reduce((a, b) => a.value.rank < b.value.rank ? a : b).key;
  }
}
