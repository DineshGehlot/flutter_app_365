import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());

  @override
  void initState() {
    super.initState();
    final names = context.read<GameProvider>().playerNames;
    for (var i = 0; i < 4 && i < names.length; i++) {
      _controllers[i].text = names[i];
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [GameConstants.cardTableGreen, Color(0xFF0B3D1E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    '365',
                    style: TextStyle(
                                            fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: GameConstants.textGold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Enter Player Names',
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                  const SizedBox(height: 32),
                  ...List.generate(4, (i) => _nameField(i)),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _startGame,
                    icon: const Icon(Icons.play_circle, size: 28),
                    label: const Text('Start Game', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GameConstants.accentCyan,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).pushNamed('/rules'),
                    icon: const Icon(Icons.help_outline, color: Colors.white70),
                    label: const Text('Game Rules', style: TextStyle(color: Colors.white70)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _nameField(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
      child: TextField(
        controller: _controllers[index],
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: 'Player ${index + 1}',
          labelStyle: const TextStyle(color: Colors.white70),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: GameConstants.accentCyan),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: GameConstants.textGold, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.black.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  void _startGame() {
    final names = _controllers.asMap().entries.map((e) {
      final text = e.value.text.trim();
      return text.isEmpty ? 'Player ${e.key + 1}' : text;
    }).toList();
    context.read<GameProvider>().setPlayerNames(names);
    Navigator.of(context).pushReplacementNamed('/game');
  }
}

