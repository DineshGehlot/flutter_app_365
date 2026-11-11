import '../utils/constants.dart';

int calculateRoundScore(int bid, int handsWon, bool isNill) {
  if (isNill) {
    return handsWon == 0 ? 99 : -99;
  }

  if (handsWon == bid) {
    return bid * 10;
  }

  if (handsWon < bid) {
    return -(bid * 10);
  }

  final overtricks = handsWon - bid;
  if (overtricks == 1 || overtricks == 2) {
    return (bid * 10) + overtricks;
  }

  return -(bid * 10);
}

int? checkWinner(List<int> totalScores) {
  for (var i = 0; i < totalScores.length; i++) {
    if (totalScores[i] >= GameConstants.winScore) {
      return i;
    }
  }
  return null;
}
