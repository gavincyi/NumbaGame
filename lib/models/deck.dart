import 'dart:math';
import 'card.dart';

class Deck {
  final List<NumbaCard> _cards = [];
  final Random _random = Random();

  Deck() {
    _initializeDeck();
  }

  void _initializeDeck() {
    _cards.clear();
    
    // Add number cards 1-50
    for (int i = 1; i <= 50; i++) {
      _cards.add(NumbaCard(
        type: CardType.number,
        value: i,
        id: 'number_$i',
      ));
    }

    // Add 5 Triangle function cards
    for (int i = 1; i <= 5; i++) {
      _cards.add(NumbaCard(
        type: CardType.triangle,
        id: 'triangle_$i',
      ));
    }

    // Add 5 Square function cards
    for (int i = 1; i <= 5; i++) {
      _cards.add(NumbaCard(
        type: CardType.square,
        id: 'square_$i',
      ));
    }

    // Add 5 Prime function cards
    for (int i = 1; i <= 5; i++) {
      _cards.add(NumbaCard(
        type: CardType.prime,
        id: 'prime_$i',
      ));
    }

    shuffle();
  }

  void shuffle() {
    _cards.shuffle(_random);
  }

  NumbaCard? drawCard() {
    if (_cards.isNotEmpty) {
      return _cards.removeLast();
    }
    return null;
  }

  List<NumbaCard> drawCards(int count) {
    final drawnCards = <NumbaCard>[];
    for (int i = 0; i < count && _cards.isNotEmpty; i++) {
      final card = drawCard();
      if (card != null) {
        drawnCards.add(card);
      }
    }
    return drawnCards;
  }

  int get remainingCards => _cards.length;

  bool get isEmpty => _cards.isEmpty;

  void reset() {
    _initializeDeck();
  }
}