import '../utils/constants.dart';

class CardModel {
  final int id;
  final Suit suit;
  final int rank;
  final bool isTrump;

  CardModel({required this.id, required this.suit, required this.rank})
      : isTrump = suit == Suit.clubs;

  factory CardModel.fromId(int id) {
    return CardModel(id: id, suit: id.toSuit, rank: id.toRank);
  }

  String get name => id.toCardName;
  String get assetName => id.toAssetName;

  int compareTo(CardModel other, Suit faceSuit) {
    if (isTrump && !other.isTrump) return 1;
    if (!isTrump && other.isTrump) return -1;
    if (suit == other.suit) {
      return rank.compareTo(other.rank);
    }
    if (suit == faceSuit) return 1;
    if (other.suit == faceSuit) return -1;
    return rank.compareTo(other.rank);
  }

  @override
  String toString() => name;
}
