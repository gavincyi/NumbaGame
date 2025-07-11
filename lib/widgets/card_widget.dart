import 'package:flutter/material.dart';
import '../models/card.dart';

enum CardSize { small, medium, large }

class CardWidget extends StatelessWidget {
  final NumbaCard card;
  final CardSize size;
  final VoidCallback? onTap;
  final bool isSelected;

  const CardWidget({
    super.key,
    required this.card,
    this.size = CardSize.medium,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final dimensions = _getDimensions();
    final color = _getCardColor();
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: dimensions.width,
        height: dimensions.height,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.black,
            width: isSelected ? 3 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              card.displaySymbol,
              style: TextStyle(
                fontSize: _getFontSize(),
                fontWeight: FontWeight.bold,
                color: _getTextColor(),
              ),
            ),
            if (card.type != CardType.number) ...[
              const SizedBox(height: 4),
              Text(
                card.displayName,
                style: TextStyle(
                  fontSize: _getFontSize() * 0.6,
                  color: _getTextColor(),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Size _getDimensions() {
    switch (size) {
      case CardSize.small:
        return const Size(40, 60);
      case CardSize.medium:
        return const Size(60, 80);
      case CardSize.large:
        return const Size(80, 120);
    }
  }

  double _getFontSize() {
    switch (size) {
      case CardSize.small:
        return 16;
      case CardSize.medium:
        return 24;
      case CardSize.large:
        return 32;
    }
  }

  Color _getCardColor() {
    switch (card.type) {
      case CardType.number:
        return Colors.white;
      case CardType.triangle:
        return Colors.red.shade100;
      case CardType.square:
        return Colors.blue.shade100;
      case CardType.prime:
        return Colors.green.shade100;
    }
  }

  Color _getTextColor() {
    switch (card.type) {
      case CardType.number:
        return Colors.black;
      case CardType.triangle:
        return Colors.red.shade800;
      case CardType.square:
        return Colors.blue.shade800;
      case CardType.prime:
        return Colors.green.shade800;
    }
  }
}