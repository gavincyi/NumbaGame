import 'dart:math';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'card.dart';
import 'deck.dart';
import 'player.dart';
import 'robot_intelligence.dart';
import '../utils/prime_checker.dart';

enum GamePhase {
  setup,
  playing,
  finished,
}

class PlayHistoryEntry {
  final String playerName;
  final NumbaCard card;
  final int tableSum;
  final bool isPrime;
  final int cardsCollected;
  final int playerScore;
  final DateTime timestamp;
  final String description;

  PlayHistoryEntry({
    required this.playerName,
    required this.card,
    required this.tableSum,
    required this.isPrime,
    required this.cardsCollected,
    required this.playerScore,
    required this.timestamp,
    required this.description,
  });
}

class GameState {
  final List<Player> players;
  final Deck deck;
  final List<NumbaCard> tableCards; // Cards on the table
  final List<NumbaCard> playedCards; // All cards played so far (for Guru intelligence)
  final List<PlayHistoryEntry> playHistory = []; // Game play history
  final Random _random = Random();
  
  int currentPlayerIndex;
  GamePhase phase;
  Player? winner;
  Timer? _robotTimer;
  String? lastAction; // For UI feedback
  bool requiresNonPrimeCard = false; // Track if current player must play non-prime card
  
  // Callback for UI updates
  VoidCallback? onStateChanged;
  
  GameState({
    required this.players,
    required this.deck,
    this.currentPlayerIndex = 0,
    this.phase = GamePhase.setup,
  }) : tableCards = [],
       playedCards = [];

  Player get currentPlayer => players[currentPlayerIndex];

  void startGame() {
    if (phase != GamePhase.setup) return;
    
    // Deal 5 cards to each player
    for (final player in players) {
      final cards = deck.drawCards(5);
      player.addCards(cards);
    }
    
    phase = GamePhase.playing;
    
    // Start with human player (index 0)
    currentPlayerIndex = 0;
    lastAction = 'Game started! Place a card on the table.';
  }

  bool playCard(NumbaCard card) {
    if (phase != GamePhase.playing) return false;
    
    final player = currentPlayer;
    if (!player.hasCard(card)) return false;
    
    // If player is required to play a non-prime card, validate it
    if (requiresNonPrimeCard) {
      if (card.value == null || PrimeChecker.isPrime(card.value!)) {
        // Invalid: player must play a non-prime card
        return false;
      }
    }
    
    // Remove card from player's hand and place on table
    player.removeCard(card);
    tableCards.add(card);
    playedCards.add(card);
    
    // Check if sum is prime
    final sum = _calculateTableSum();
    final isPrimeSum = PrimeChecker.isPrime(sum);
    
    if (requiresNonPrimeCard) {
      // Player was required to play a non-prime card and did so
      // Add to play history
      playHistory.add(PlayHistoryEntry(
        playerName: player.name,
        card: card,
        tableSum: sum,
        isPrime: false,
        cardsCollected: 0,
        playerScore: player.score,
        timestamp: DateTime.now(),
        description: '${player.name} played non-prime card ${card.displayName} (required after scoring), table sum is $sum',
      ));
      
      lastAction = '${player.name} placed non-prime card ${card.value}. Table sum: $sum';
      
      // Draw a card if deck is not empty to maintain 5 cards
      if (!deck.isEmpty) {
        final drawnCard = deck.drawCard();
        if (drawnCard != null) {
          player.addCard(drawnCard);
        }
      }
      
      // Clear the requirement and move to next player
      requiresNonPrimeCard = false;
      _nextPlayer();
    } else if (isPrimeSum) {
      // Player collects all cards on table
      final collectedCount = tableCards.length;
      player.collectCards(List.from(tableCards));
      
      // Add to play history
      playHistory.add(PlayHistoryEntry(
        playerName: player.name,
        card: card,
        tableSum: sum,
        isPrime: true,
        cardsCollected: collectedCount,
        playerScore: player.score,
        timestamp: DateTime.now(),
        description: '${player.name} played ${card.displayName}, created prime sum $sum, collected $collectedCount cards',
      ));
      
      tableCards.clear();
      lastAction = '${player.name} collected $collectedCount cards! (Sum: $sum is prime) Score: ${player.score}. Must play a non-prime card.';
      
      // Player must draw a card to maintain 5 cards, then place a non-prime card
      if (!deck.isEmpty) {
        final drawnCard = deck.drawCard();
        if (drawnCard != null) {
          player.addCard(drawnCard);
        }
      }
      
      // Set requirement for non-prime card
      requiresNonPrimeCard = true;
      
      // For robots, automatically handle non-prime requirement
      if (player.isRobot) {
        _handleRobotNonPrimeRequirement(player);
      }
      // For humans, the UI will show they need to play a non-prime card
    } else {
      // Add to play history
      playHistory.add(PlayHistoryEntry(
        playerName: player.name,
        card: card,
        tableSum: sum,
        isPrime: false,
        cardsCollected: 0,
        playerScore: player.score,
        timestamp: DateTime.now(),
        description: '${player.name} played ${card.displayName}, table sum is $sum (not prime)',
      ));
      
      lastAction = '${player.name} placed ${card.value}. Table sum: $sum';
      
      // Draw a card if deck is not empty to maintain 5 cards
      if (!deck.isEmpty) {
        final drawnCard = deck.drawCard();
        if (drawnCard != null) {
          player.addCard(drawnCard);
        }
      }
      
      // Move to next player
      _nextPlayer();
    }
    
    // Check if game should end (deck empty)
    if (deck.isEmpty && !isPrimeSum) {
      _endGame();
    }
    
    return true;
  }

  // Draw card is no longer a separate action in new rules
  // Cards are drawn automatically after placing a card

  void _nextPlayer({bool triggerRobot = true}) {
    currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
    
    // If it's a robot's turn, automatically play after a delay
    if (currentPlayer.isRobot && phase == GamePhase.playing && triggerRobot) {
      _robotTimer?.cancel();
      
      // Different thinking times based on intelligence level
      int thinkingTime = 1500; // default fallback
      if (currentPlayer.intelligence != null) {
        switch (currentPlayer.intelligence!.level) {
          case RobotIntelligenceLevel.toddler:
            thinkingTime = 100;
            break;
          case RobotIntelligenceLevel.adult:
            thinkingTime = 200;
            break;
          case RobotIntelligenceLevel.guru:
            thinkingTime = 800;
            break;
        }
      }
      
      _robotTimer = Timer(Duration(milliseconds: thinkingTime), () {
        _robotPlay();
      });
    }
  }
  
  void triggerRobotPlay() {
    _robotPlay();
  }
  
  void _robotPlay() {
    if (phase != GamePhase.playing || !currentPlayer.isRobot) return;
    
    print('Robot ${currentPlayer.name} is playing...');
    
    // Robot uses intelligence to select card
    if (currentPlayer.hand.isNotEmpty) {
      NumbaCard? selectedCard;
      
      if (currentPlayer.intelligence != null) {
        selectedCard = currentPlayer.intelligence!.selectCard(
          currentPlayer,
          tableCards,
          playedCards,
        );
      }
      
      // Fallback to random card if no intelligence or no card selected
      selectedCard ??= currentPlayer.hand[_random.nextInt(currentPlayer.hand.length)];
      
      print('Robot playing card: ${selectedCard.displayName}');
      playCard(selectedCard);
    }
    
    // Notify UI of state change
    onStateChanged?.call();
  }
  
  int _calculateTableSum() {
    return tableCards.fold(0, (sum, card) => sum + (card.value ?? 0));
  }
  
  void _handleRobotNonPrimeRequirement(Player player) {
    // Find non-prime cards in player's hand
    final nonPrimeCards = player.hand.where((card) => 
        card.value != null && !PrimeChecker.isPrime(card.value!)).toList();
    
    if (nonPrimeCards.isNotEmpty) {
      NumbaCard cardToPlay;
      
      if (player.intelligence != null) {
        // Use intelligence to select from non-prime cards
        final selectedCard = player.intelligence!.selectCard(
          Player(
            id: player.id,
            name: player.name,
            type: player.type,
            initialHand: nonPrimeCards,
            intelligence: player.intelligence,
          ),
          tableCards,
          playedCards,
        );
        cardToPlay = selectedCard ?? nonPrimeCards[_random.nextInt(nonPrimeCards.length)];
      } else {
        cardToPlay = nonPrimeCards[_random.nextInt(nonPrimeCards.length)];
      }
      
      // Use the regular playCard method to handle the non-prime card
      // This will automatically handle the requiresNonPrimeCard flag
      playCard(cardToPlay);
    } else {
      // No non-prime cards available, clear requirement and move to next player
      requiresNonPrimeCard = false;
      _nextPlayer();
    }
  }
  
  void _endGame() {
    phase = GamePhase.finished;
    _robotTimer?.cancel();
    
    // Find winner (highest score)
    Player? highestScorer;
    int highestScore = -1;
    
    for (final player in players) {
      if (player.score > highestScore) {
        highestScore = player.score;
        highestScorer = player;
      }
    }
    
    winner = highestScorer;
    lastAction = 'Game Over! ${winner?.name} wins with ${winner?.score} points!';
    onStateChanged?.call();
  }
  
  List<NumbaCard> getNonPrimeCards(Player player) {
    return player.hand.where((card) => 
        card.value != null && !PrimeChecker.isPrime(card.value!)).toList();
  }

  void reset() {
    _robotTimer?.cancel();
    phase = GamePhase.setup;
    currentPlayerIndex = 0;
    winner = null;
    requiresNonPrimeCard = false;
    tableCards.clear();
    playedCards.clear();
    playHistory.clear();
    lastAction = null;
    
    // Clear all player hands and collected cards
    for (final player in players) {
      player.hand.clear();
      player.collectedCards.clear();
    }
    
    // Reset deck
    deck.reset();
  }
  
  void dispose() {
    _robotTimer?.cancel();
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPlayerIndex': currentPlayerIndex,
      'phase': phase.name,
      'playerCount': players.length,
      'deckSize': deck.remainingCards,
      'tableCardsCount': tableCards.length,
      'tableSum': _calculateTableSum(),
      'winner': winner?.name,
    };
  }
}