import 'dart:math';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'card.dart';
import 'deck.dart';
import 'player.dart';

enum GamePhase {
  setup,
  playing,
  finished,
}

class GameState {
  final List<Player> players;
  final Deck deck;
  final List<NumbaCard> playedCards;
  final Random _random = Random();
  
  int currentPlayerIndex;
  GamePhase phase;
  Player? winner;
  Timer? _robotTimer;
  
  // Callback for UI updates
  VoidCallback? onStateChanged;
  
  GameState({
    required this.players,
    required this.deck,
    this.currentPlayerIndex = 0,
    this.phase = GamePhase.setup,
  }) : playedCards = [];

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
  }

  bool playCard(NumbaCard card) {
    if (phase != GamePhase.playing) return false;
    
    final player = currentPlayer;
    if (!player.hasCard(card)) return false;
    
    // Remove card from player's hand
    player.removeCard(card);
    playedCards.add(card);
    
    // Check if player won
    if (player.hasWon) {
      winner = player;
      phase = GamePhase.finished;
      _robotTimer?.cancel(); // Stop any robot timers
      onStateChanged?.call(); // Notify UI immediately
      return true;
    }
    
    // Move to next player
    _nextPlayer();
    return true;
  }

  bool drawCard() {
    if (phase != GamePhase.playing) return false;
    
    final card = deck.drawCard();
    if (card == null) return false;
    
    currentPlayer.addCard(card);
    
    // Move to next player
    _nextPlayer();
    return true;
  }

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
    
    // For now, always play a random card to ensure progress
    if (currentPlayer.hand.isNotEmpty) {
      final randomCard = currentPlayer.hand[_random.nextInt(currentPlayer.hand.length)];
      print('Robot playing card: ${randomCard.displayName}');
      playCard(randomCard);
    } else {
      // If no cards in hand, try to draw
      if (!deck.isEmpty) {
        print('Robot drawing card');
        drawCard();
      }
    }
    
    // Notify UI of state change
    onStateChanged?.call();
  }

  void reset() {
    _robotTimer?.cancel();
    phase = GamePhase.setup;
    currentPlayerIndex = 0;
    winner = null;
    playedCards.clear();
    
    // Clear all player hands
    for (final player in players) {
      player.hand.clear();
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
      'playedCardsCount': playedCards.length,
      'winner': winner?.name,
    };
  }
}