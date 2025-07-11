import 'dart:math';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'card.dart';
import 'deck.dart';
import 'player.dart';
import '../utils/prime_checker.dart';

enum GamePhase {
  setup,
  playing,
  finished,
}

class GameState {
  final List<Player> players;
  final Deck deck;
  final List<NumbaCard> tableCards; // Cards on the table
  final Random _random = Random();
  
  int currentPlayerIndex;
  GamePhase phase;
  Player? winner;
  Timer? _robotTimer;
  String? lastAction; // For UI feedback
  
  // Callback for UI updates
  VoidCallback? onStateChanged;
  
  GameState({
    required this.players,
    required this.deck,
    this.currentPlayerIndex = 0,
    this.phase = GamePhase.setup,
  }) : tableCards = [];

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
    
    // Remove card from player's hand and place on table
    player.removeCard(card);
    tableCards.add(card);
    
    // Check if sum is prime
    final sum = _calculateTableSum();
    final isPrimeSum = PrimeChecker.isPrime(sum);
    
    if (isPrimeSum) {
      // Player collects all cards on table
      final collectedCount = tableCards.length;
      player.collectCards(List.from(tableCards));
      tableCards.clear();
      lastAction = '${player.name} collected $collectedCount cards! (Sum: $sum is prime) Score: ${player.score}';
      
      // Player must draw a card to maintain 5 cards, then place a non-prime card
      if (!deck.isEmpty) {
        final drawnCard = deck.drawCard();
        if (drawnCard != null) {
          player.addCard(drawnCard);
        }
      }
      
      // Player must place a non-prime card if possible
      _handleNonPrimeRequirement(player);
    } else {
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

  void _nextPlayer() {
    currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
    
    // If it's a robot's turn, automatically play after a delay
    if (currentPlayer.isRobot && phase == GamePhase.playing) {
      _robotTimer?.cancel();
      _robotTimer = Timer(const Duration(milliseconds: 1500), () {
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
    
    // Robot plays a random card from hand
    if (currentPlayer.hand.isNotEmpty) {
      final randomCard = currentPlayer.hand[_random.nextInt(currentPlayer.hand.length)];
      print('Robot playing card: ${randomCard.displayName}');
      playCard(randomCard);
    }
    
    // Notify UI of state change
    onStateChanged?.call();
  }
  
  int _calculateTableSum() {
    return tableCards.fold(0, (sum, card) => sum + (card.value ?? 0));
  }
  
  void _handleNonPrimeRequirement(Player player) {
    // Find non-prime cards in player's hand
    final nonPrimeCards = player.hand.where((card) => 
        card.value != null && !PrimeChecker.isPrime(card.value!)).toList();
    
    if (nonPrimeCards.isNotEmpty) {
      // For robots, automatically play a non-prime card
      if (player.isRobot) {
        final cardToPlay = nonPrimeCards[_random.nextInt(nonPrimeCards.length)];
        player.removeCard(cardToPlay);
        tableCards.add(cardToPlay);
        lastAction = '${player.name} placed non-prime card ${cardToPlay.value}. Table sum: ${_calculateTableSum()}';
        
        // Draw a card if deck is not empty to maintain 5 cards
        if (!deck.isEmpty) {
          final drawnCard = deck.drawCard();
          if (drawnCard != null) {
            player.addCard(drawnCard);
          }
        }
      }
      // For human players, the UI will handle the non-prime requirement
    }
    
    // Move to next player
    _nextPlayer();
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
    tableCards.clear();
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