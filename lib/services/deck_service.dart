import 'dart:math';
import '../models/card.dart';
import '../models/player.dart';
import '../utils/constants.dart';

class DeckService {
  static List<CardModel> createDeck() {
    return List.generate(52, (i) => CardModel.fromId(i + 1));
  }

  static List<CardModel> shuffle(List<CardModel> deck, [int? seed]) {
    final shuffled = List<CardModel>.from(deck);
    final random = seed != null ? Random(seed) : Random();
    for (var i = shuffled.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = shuffled[i];
      shuffled[i] = shuffled[j];
      shuffled[j] = temp;
    }
    return shuffled;
  }

  static void deal(List<CardModel> deck, List<Player> players) {
    for (var p in players) p.clearHand();
    for (var i = 0; i < deck.length; i++) {
      final playerIndex = i % players.length;
      players[playerIndex].addCard(deck[i]);
    }
  }
}



