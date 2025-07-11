import 'card.dart';

enum PlayerType { human, robot }

class Player {
  final String id;
  final String name;
  final PlayerType type;
  final List<NumbaCard> hand;
  final List<NumbaCard> collectedCards; // Cards collected from table

  Player({
    required this.id,
    required this.name,
    required this.type,
    List<NumbaCard>? initialHand,
  }) : hand = initialHand ?? [],
       collectedCards = [];

  bool get isHuman => type == PlayerType.human;
  bool get isRobot => type == PlayerType.robot;

  void addCard(NumbaCard card) {
    hand.add(card);
  }

  void addCards(List<NumbaCard> cards) {
    hand.addAll(cards);
  }

  bool removeCard(NumbaCard card) {
    return hand.remove(card);
  }

  int get cardCount => hand.length;

  bool get hasWon => false; // Win condition changed to highest score

  bool hasCard(NumbaCard card) {
    return hand.contains(card);
  }

  void collectCards(List<NumbaCard> cards) {
    collectedCards.addAll(cards);
  }

  int get score {
    return collectedCards.fold(0, (sum, card) => sum + (card.value ?? 0));
  }

  int get collectedCount => collectedCards.length;

  @override
  String toString() {
    return 'Player(id: $id, name: $name, type: $type, cards: ${hand.length}, score: $score)';
  }
}