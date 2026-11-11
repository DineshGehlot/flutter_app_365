library flutter_app_365.models.score_record;

class ScoreRecord {
  final int roundNumber;
  final List<int> roundScores; // per player scores for this round
  final List<int> totalScores; // cumulative totals after this round

  ScoreRecord({
    required this.roundNumber,
    required this.roundScores,
    required this.totalScores,
  });
}
