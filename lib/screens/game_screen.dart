import 'package:flutter/material.dart';
import '../models/card.dart';
import '../models/deck.dart';
import '../models/player.dart';
import '../models/game_state.dart';
import '../widgets/card_widget.dart';
import '../widgets/player_hand.dart';
import '../services/audio_service.dart';

class GameScreen extends StatefulWidget {
  final int playerCount;

  const GameScreen({
    super.key,
    required this.playerCount,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameState gameState;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  @override
  void dispose() {
    gameState.dispose();
    super.dispose();
  }

  void _initializeGame() {
    final deck = Deck();
    final players = <Player>[];
    
    // First player is human, others are robots
    for (int i = 0; i < widget.playerCount; i++) {
      players.add(Player(
        id: 'player_$i',
        name: i == 0 ? 'You' : 'Robot ${i}',
        type: i == 0 ? PlayerType.human : PlayerType.robot,
      ));
    }

    gameState = GameState(
      players: players,
      deck: deck,
    );

    // Set up callback for state changes
    gameState.onStateChanged = () {
      if (mounted) {
        setState(() {});
        // Check if game ended and show winner dialog
        if (gameState.phase == GamePhase.finished) {
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              AudioService().playWinSound();
              _showWinnerDialog();
            }
          });
        }
      }
    };

    gameState.startGame();
    
    // Start background music
    AudioService().playBackgroundMusic();
    
    // If the first player is a robot, trigger robot play
    if (gameState.currentPlayer.isRobot) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          gameState.triggerRobotPlay();
        }
      });
    }
  }

  void _onCardTap(NumbaCard card) {
    if (gameState.phase != GamePhase.playing) return;
    if (!gameState.currentPlayer.isHuman) return; // Only human can tap cards
    
    setState(() {
      final success = gameState.playCard(card);
      if (success) {
        AudioService().playCardSound();
        // Winner dialog will be shown by state change callback
      }
    });
  }

  void _onDrawCard() {
    if (gameState.phase != GamePhase.playing) return;
    if (!gameState.currentPlayer.isHuman) return; // Only human can draw cards
    
    setState(() {
      final success = gameState.drawCard();
      if (success) {
        AudioService().playDrawSound();
      }
    });
  }

  void _showWinnerDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Over!'),
        content: Text('${gameState.winner?.name} wins!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _initializeGame();
              });
            },
            child: const Text('Play Again'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Back to Menu'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Numba'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _initializeGame();
              });
            },
          ),
        ],
      ),
      body: gameState.phase == GamePhase.setup
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Game status
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Current Turn: ${gameState.currentPlayer.name}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Cards in deck: ${gameState.deck.remainingCards}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                
                // Robot players' card counts (skip human player)
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: gameState.players.length - 1, // Exclude human player
                    itemBuilder: (context, index) {
                      final player = gameState.players[index + 1]; // Skip human player (index 0)
                      
                      return Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: player == gameState.currentPlayer 
                                ? Colors.blue 
                                : Colors.grey,
                            width: player == gameState.currentPlayer ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: player == gameState.currentPlayer 
                              ? Colors.blue.shade50 
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.android,
                                  size: 16,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  player.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('${player.cardCount} cards'),
                            if (player == gameState.currentPlayer)
                              const Text(
                                'Playing...',
                                style: TextStyle(fontSize: 12, color: Colors.blue),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                
                // Played cards area
                Container(
                  height: 120,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'Played Cards',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: gameState.playedCards.isEmpty
                            ? const Center(child: Text('No cards played yet'))
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: gameState.playedCards.length,
                                itemBuilder: (context, index) {
                                  final card = gameState.playedCards[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 2),
                                    child: CardWidget(
                                      card: card,
                                      size: CardSize.small,
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
                
                // Human player's hand (always show)
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'Your Hand',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: PlayerHand(
                            cards: gameState.players[0].hand, // Always show human player's cards
                            onCardTap: gameState.currentPlayer.isHuman ? _onCardTap : null,
                            isCurrentPlayer: gameState.currentPlayer.isHuman,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Action buttons (only show for human player)
                if (gameState.currentPlayer.isHuman)
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          'Your Turn: Tap a card to play or draw a new card',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: gameState.deck.isEmpty ? null : _onDrawCard,
                          icon: const Icon(Icons.add),
                          label: const Text('Draw Card'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(160, 50),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // Robot turn indicator
                if (gameState.currentPlayer.isRobot)
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.android, color: Colors.green),
                            const SizedBox(width: 8),
                            Text(
                              '${gameState.currentPlayer.name} is thinking...',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const CircularProgressIndicator(),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}