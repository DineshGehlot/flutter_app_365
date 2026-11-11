import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw StateError('StorageService not initialized. Call init() first.');
    }
    return _prefs!;
  }

  static const String _keyPlayerNames = 'player_names';
  static const String _keyTotalScores = 'total_scores';
  static const String _keyRoundNumber = 'round_number';

  static Future<List<String>> getPlayerNames() async {
    final list = prefs.getStringList(_keyPlayerNames) ?? [];
    if (list.length < 4) {
      return ['Player 1', 'Player 2', 'Player 3', 'Player 4'];
    }
    return list;
  }

  static Future<void> savePlayerNames(List<String> names) async {
    await prefs.setStringList(_keyPlayerNames, names);
  }

  static Future<List<int>> getTotalScores() async {
    final list = prefs.getStringList(_keyTotalScores) ?? [];
    return list.map((e) => int.tryParse(e) ?? 0).toList();
  }

  static Future<void> saveTotalScores(List<int> scores) async {
    await prefs.setStringList(_keyTotalScores, scores.map((e) => e.toString()).toList());
  }

  static Future<int> getRoundNumber() async {
    return prefs.getInt(_keyRoundNumber) ?? 1;
  }

  static Future<void> saveRoundNumber(int round) async {
    await prefs.setInt(_keyRoundNumber, round);
  }

  static Future<void> resetGame() async {
    await saveTotalScores([0, 0, 0, 0]);
    await prefs.setInt(_keyRoundNumber, 1);
  }
}
