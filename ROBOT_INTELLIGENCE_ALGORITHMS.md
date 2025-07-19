# Robot Intelligence Algorithms

## Overview
The Numba game now includes three levels of robot intelligence to provide varying levels of challenge and gameplay experience.

## Intelligence Levels

### 1. Toddler (Random Play)
**Algorithm:** Simple random selection
**Description:** Plays cards randomly from hand without any strategy consideration.

**Implementation:**
```dart
NumbaCard _toddlerStrategy(Player player) {
  return player.hand[_random.nextInt(player.hand.length)];
}
```

**Key Features:**
- No strategy or calculation involved
- Pure random selection from available cards
- Fastest execution time
- Unpredictable gameplay

**Use Case:** 
- Beginner players who want to learn the game
- When you want unpredictable, casual gameplay
- Testing game mechanics without strategic interference

---

### 2. Adult (Best Card Search)
**Algorithm:** Greedy best-move search
**Description:** Evaluates each possible card play and selects the one with the highest immediate score.

**Implementation:**
```dart
NumbaCard _adultStrategy(Player player, List<NumbaCard> tableCards) {
  final currentSum = tableCards.fold(0, (sum, card) => sum + (card.value ?? 0));
  
  NumbaCard? bestCard;
  int bestScore = -1;
  
  for (final card in player.hand) {
    if (card.value == null) continue;
    
    final newSum = currentSum + card.value!;
    int score = 0;
    
    // If playing this card makes the sum prime, score = number of cards collected
    if (PrimeChecker.isPrime(newSum)) {
      score = tableCards.length + 1; // +1 for the card being played
    } else {
      score = 0; // No immediate benefit
    }
    
    if (score > bestScore) {
      bestScore = score;
      bestCard = card;
    }
  }
  
  return bestCard ?? player.hand[0];
}
```

**Key Features:**
- Evaluates immediate consequences of each move
- Prioritizes moves that create prime sums (collecting cards)
- Greedy approach - only looks one move ahead
- Balances strategy with reasonable execution time

**Scoring Logic:**
- Prime sum creation: +N points (where N = cards collected)
- Non-prime sum: 0 points
- Selects card with highest immediate score

**Use Case:**
- Intermediate players who want some challenge
- Players learning strategic thinking
- Balanced gameplay experience

---

### 3. Guru (Optimal Strategy with Card Counting)
**Algorithm:** Advanced strategic evaluation with card counting
**Description:** Uses card counting and multi-factor evaluation to make optimal decisions.

**Implementation:**
```dart
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
  
  // Primary factor: Prime sum creation
  if (PrimeChecker.isPrime(newSum)) {
    score += (tableCards.length + 1) * 10.0; // High weight for collecting cards
  } else {
    score -= 5.0; // Penalty for not collecting
  }
  
  // Secondary factor: Card value optimization
  if (card.value != null) {
    score += card.value! * 0.1; // Slight preference for higher value cards
  }
  
  // Advanced factor: Future move analysis
  final remainingCards = _getRemainingCards(playedCards);
  for (final futureCard in remainingCards) {
    if (futureCard.value == null) continue;
    
    final futureSum = newSum + futureCard.value!;
    if (PrimeChecker.isPrime(futureSum)) {
      score -= 2.0; // Penalty for setting up opponents
    }
  }
  
  return score;
}
```

**Key Features:**
- **Card Counting:** Tracks all played cards to know what remains
- **Multi-factor Evaluation:** Considers multiple strategic factors
- **Future Analysis:** Predicts potential opponent moves
- **Weighted Scoring:** Uses different weights for different factors

**Scoring Factors:**
1. **Prime Sum Creation:** +N*10 points (highest priority)
2. **Non-prime Penalty:** -5 points
3. **Card Value Optimization:** +0.1 * card_value points
4. **Future Move Analysis:** -2 points for each potential opponent prime

**Strategic Considerations:**
- Maximizes own card collection opportunities
- Minimizes opportunities for opponents
- Considers card value when scores are equal
- Uses probability analysis based on remaining cards

**Use Case:**
- Advanced players seeking maximum challenge
- Competitive gameplay
- Learning optimal strategies
- Testing player skill against near-perfect play

---

## Algorithm Comparison

| Feature | Toddler | Adult | Guru |
|---------|---------|--------|------|
| **Complexity** | O(1) | O(n) | O(n*m) |
| **Look-ahead** | None | 1 move | Multiple moves |
| **Card Counting** | No | No | Yes |
| **Strategic Factors** | 0 | 1 | 4+ |
| **Execution Time** | Instant | Fast | Moderate |
| **Difficulty Level** | Easy | Medium | Hard |

Where:
- n = number of cards in hand
- m = number of remaining cards in deck

## Implementation Notes

### Performance Considerations
- Toddler: Minimal CPU usage, instant decisions
- Adult: Light calculation, quick decisions
- Guru: Moderate CPU usage, slight delay for realistic "thinking" time

### Extensibility
The system is designed to be easily extended with additional intelligence levels or modified strategies. Each level is self-contained and can be adjusted independently.

### Testing
Each intelligence level has been tested for:
- Correctness of card selection
- Performance under various game states
- Strategic effectiveness
- User experience and fun factor