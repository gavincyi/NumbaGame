import 'dart:math';
import 'card.dart';

class Deck {
  final List<NumbaCard> _cards = [];
  final Random _random = Random();
  final int maxNumber;

  Deck({this.maxNumber = 50}) {
    _initializeDeck();
  }

  void _initializeDeck() {
    _cards.clear();
    
    // Add number cards 1 to maxNumber
    for (int i = 1; i <= maxNumber; i++) {
      _cards.add(NumbaCard(
        type: CardType.number,
        value: i,
        id: 'number_$i',
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