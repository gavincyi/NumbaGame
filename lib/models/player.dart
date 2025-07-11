import 'card.dart';

enum PlayerType { human, robot }

class Player {
  final String id;
  final String name;
  final PlayerType type;
  final List<NumbaCard> hand;

  Player({
    required this.id,
    required this.name,
    required this.type,
    List<NumbaCard>? initialHand,
  }) : hand = initialHand ?? [];

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

  bool get hasWon => hand.isEmpty;

  bool hasCard(NumbaCard card) {
    return hand.contains(card);
  }

  @override
  String toString() {
    return 'Player(id: $id, name: $name, type: $type, cards: ${hand.length})';
  }
}