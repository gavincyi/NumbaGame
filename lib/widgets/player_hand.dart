import 'package:flutter/material.dart';
import '../models/card.dart';
import 'card_widget.dart';

class PlayerHand extends StatelessWidget {
  final List<NumbaCard> cards;
  final Function(NumbaCard)? onCardTap;
  final bool isCurrentPlayer;

  const PlayerHand({
    super.key,
    required this.cards,
    this.onCardTap,
    this.isCurrentPlayer = false,
  });

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return const Center(
        child: Text(
          'No cards in hand',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 0.75,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];
        return CardWidget(
          card: card,
          size: CardSize.medium,
          onTap: isCurrentPlayer && onCardTap != null
              ? () => onCardTap!(card)
              : null,
        );
      },
    );
  }
}