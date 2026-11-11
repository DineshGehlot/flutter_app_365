import '../models/card.dart';
import '../utils/constants.dart';

class Player {
  final int index;
  final String name;
  final bool isHuman;
  final List<CardModel> hand;
  int bid;
  int handsWon;
  int roundScore;
  int totalScore;

  Player({
    required this.index,
    required this.name,
    this.isHuman = false,
    List<CardModel>? hand,
  })  : hand = hand ?? [],
        bid = 0,
        handsWon = 0,
        roundScore = 0,
        totalScore = 0;

  void addCard(CardModel card) {
    hand.add(card);
    hand.sort((a, b) => a.id.compareTo(b.id));
  }

  void clearHand() {
    hand.clear();
    bid = 0;
    handsWon = 0;
    roundScore = 0;
  }

  CardModel? playCard(int cardIndex) {
    if (cardIndex < 0 || cardIndex >= hand.length) return null;
    return hand.removeAt(cardIndex);
  }

  bool hasSuit(Suit suit) => hand.any((c) => c.suit == suit);
}
