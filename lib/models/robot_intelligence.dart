import 'dart:math';
import 'card.dart';
import 'player.dart';
import '../utils/prime_checker.dart';

enum RobotIntelligenceLevel { toddler, adult, guru }

class RobotIntelligence {
  final RobotIntelligenceLevel level;
  final Random _random = Random();
  
  RobotIntelligence(this.level);
  
  String get levelName {
    switch (level) {
      case RobotIntelligenceLevel.toddler:
        return 'Toddler';
      case RobotIntelligenceLevel.adult:
        return 'Adult';
      case RobotIntelligenceLevel.guru:
        return 'Guru';
    }
  }
  
  String get levelDescription {
    switch (level) {
      case RobotIntelligenceLevel.toddler:
        return 'Plays random cards';
      case RobotIntelligenceLevel.adult:
        return 'Searches for best moves';
      case RobotIntelligenceLevel.guru:
        return 'Uses optimal strategy';
    }
  }
  
  NumbaCard? selectCard(Player player, List<NumbaCard> tableCards, List<NumbaCard> playedCards) {
    if (player.hand.isEmpty) return null;
    
    switch (level) {
      case RobotIntelligenceLevel.toddler:
        return _toddlerStrategy(player);
      case RobotIntelligenceLevel.adult:
        return _adultStrategy(player, tableCards);
      case RobotIntelligenceLevel.guru:
        return _guruStrategy(player, tableCards, playedCards);
    }
  }
  
  NumbaCard _toddlerStrategy(Player player) {
    return player.hand[_random.nextInt(player.hand.length)];
  }
  
  NumbaCard _adultStrategy(Player player, List<NumbaCard> tableCards) {
    final currentSum = tableCards.fold(0, (sum, card) => sum + (card.value ?? 0));
    
    NumbaCard? bestCard;
    int bestScore = -1;
    
    for (final card in player.hand) {
      if (card.value == null) continue;
      
      final newSum = currentSum + card.value!;
      int score = 0;
      
      if (PrimeChecker.isPrime(newSum)) {
        score = tableCards.length + 1;
      } else {
        score = 0;
      }
      
      if (score > bestScore) {
        bestScore = score;
        bestCard = card;
      }
    }
    
    return bestCard ?? player.hand[0];
  }
  
  NumbaCard _guruStrategy(Player player, List<NumbaCard> tableCards, List<NumbaCard> playedCards) {
    final currentSum = tableCards.fold(0, (sum, card) => sum + (card.value ?? 0));
    
    NumbaCard? bestCard;
    double bestScore = -1000.0;
    
    for (final card in player.hand) {
      if (card.value == null) continue;
      
      final newSum = currentSum + card.value!;
      double score = _evaluateMove(card, newSum, tableCards, playedCards);
      
      if (score > bestScore) {
        bestScore = score;
        bestCard = card;
      }
    }
    
    return bestCard ?? player.hand[0];
  }
  
  double _evaluateMove(NumbaCard card, int newSum, List<NumbaCard> tableCards, List<NumbaCard> playedCards) {
    double score = 0.0;
    
    if (PrimeChecker.isPrime(newSum)) {
      score += (tableCards.length + 1) * 10.0;
    } else {
      score -= 5.0;
    }
    
    if (card.value != null) {
      score += card.value! * 0.1;
    }
    
    final remainingCards = _getRemainingCards(playedCards);
    for (final futureCard in remainingCards) {
      if (futureCard.value == null) continue;
      
      final futureSum = newSum + futureCard.value!;
      if (PrimeChecker.isPrime(futureSum)) {
        score -= 2.0;
      }
    }
    
    return score;
  }
  
  List<NumbaCard> _getRemainingCards(List<NumbaCard> playedCards) {
    final allCards = <NumbaCard>[];
    for (int i = 1; i <= 50; i++) {
      allCards.add(NumbaCard(
        type: CardType.number,
        value: i,
        id: 'card_$i',
      ));
    }
    
    final playedValues = playedCards.map((card) => card.value).toSet();
    return allCards.where((card) => !playedValues.contains(card.value)).toList();
  }
}