library flutter_app_365.widgets.bid_dialog;

import 'package:flutter/material.dart';
import '../utils/constants.dart';

class BidDialog extends StatelessWidget {
  final int currentBid;
  final void Function(int bid) onBidSelected;

  const BidDialog({
    super.key,
    required this.currentBid,
    required this.onBidSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF212121),
      title: const Text('Place Your Bid', style: TextStyle(color: Colors.white)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Select number of hands (2-13) or Nill:', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _bidChip('Nill', 0),
              for (var i = 2; i <= 13; i++) _bidChip(i.toString(), i),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
        ),
      ],
    );
  }

  Widget _bidChip(String label, int bid) {
    final isSelected = currentBid == bid;
    return ChoiceChip(
      label: Text(label == 'Nill' ? 'Nill' : label, style: const TextStyle(color: Colors.white)),
      selected: isSelected,
      onSelected: (_) => onBidSelected(bid),
      selectedColor: GameConstants.accentCyan,
      backgroundColor: const Color(0xFF333333),
    );
  }
}
