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
  final int maxCardNumber;

  const GameScreen({
    super.key,
    required this.playerCount,
    required this.maxCardNumber,
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
    final deck = Deck(maxNumber: widget.maxCardNumber);
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

  // Draw card is now automatic after placing a card
  // No separate draw action needed

  void _showWinnerDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Over!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${gameState.winner?.name} wins with ${gameState.winner?.score} points!',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Final Scores:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            for (final player in gameState.players)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(player.name),
                    Text('${player.score} points'),
                  ],
                ),
              ),
          ],
        ),
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
        title: Text('Numba (1-${widget.maxCardNumber})'),
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
                        'Cards in deck: ${gameState.deck.remainingCards}/${widget.maxCardNumber}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      // Current Scores
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: gameState.players.map((player) => Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  player.isHuman ? Icons.person : Icons.android,
                                  size: 16,
                                  color: player.isHuman ? Colors.blue : Colors.green,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  player.name,
                                  style: TextStyle(
                                    fontWeight: player == gameState.currentPlayer 
                                        ? FontWeight.bold 
                                        : FontWeight.normal,
                                    color: player == gameState.currentPlayer 
                                        ? Colors.blue 
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Score: ${player.score}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )).toList(),
                      ),
                      if (gameState.lastAction != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          gameState.lastAction!,
                          style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Player hand counts (simplified since scores are shown above)
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: gameState.players.map((player) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                      child: Text(
                        '${player.name}: ${player.cardCount} cards',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: player == gameState.currentPlayer 
                              ? FontWeight.bold 
                              : FontWeight.normal,
                        ),
                      ),
                    )).toList(),
                  ),
                ),
                
                // Table cards area
                Container(
                  height: 120,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Table Cards',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (gameState.tableCards.isNotEmpty) ...[
                            const SizedBox(width: 16),
                            Text(
                              'Sum: ${gameState.tableCards.fold(0, (sum, card) => sum + (card.value ?? 0))}',
                              style: const TextStyle(fontSize: 14, color: Colors.blue),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: gameState.tableCards.isEmpty
                            ? const Center(child: Text('No cards on table'))
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: gameState.tableCards.length,
                                itemBuilder: (context, index) {
                                  final card = gameState.tableCards[index];
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Your Hand',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Your Score: ${gameState.players[0].score}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
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
                
                // Action instructions (only show for human player)
                if (gameState.currentPlayer.isHuman)
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          'Your Turn: Tap a card to place it on the table',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'If the sum becomes prime, you collect all table cards!',
                          style: TextStyle(fontSize: 14, color: Colors.green),
                          textAlign: TextAlign.center,
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