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
  
  // List of human names for robot players
  static const List<String> _robotNames = [
    'Alex',
    'Sam',
    'Jordan',
    'Taylor',
    'Casey',
    'Riley',
    'Morgan',
    'Quinn',
    'Avery',
    'Blake',
    'Cameron',
    'Drew',
    'Emery',
    'Finley',
    'Harper',
    'Indigo',
    'Jamie',
    'Kendall',
    'Logan',
    'Mason',
    'Nova',
    'Oakley',
    'Parker',
    'River',
    'Sage',
    'Tatum',
    'Winter',
    'Zion',
    'Atlas',
    'Briar',
    'Cedar',
    'Dawn',
    'Echo',
    'Flint',
    'Grove',
    'Haven',
    'Iris',
    'Jade',
    'Kai',
    'Luna',
    'Meadow',
    'Nash',
    'Ocean',
    'Phoenix',
    'Quill',
    'Rain',
    'Sky',
    'Thunder',
    'Vale',
    'Willow',
  ];

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
    
    // Create a shuffled list of robot names
    final shuffledNames = List<String>.from(_robotNames);
    shuffledNames.shuffle();
    
    // First player is human, others are robots with random human names
    for (int i = 0; i < widget.playerCount; i++) {
      players.add(Player(
        id: 'player_$i',
        name: i == 0 ? 'You' : shuffledNames[i - 1], // Use shuffled names for robots
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
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Numba (1-${widget.maxCardNumber})',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                _initializeGame();
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1a1a2e),
              Color(0xFF16213e),
              Color(0xFF0f3460),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: gameState.phase == GamePhase.setup
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : SafeArea(
                child: Column(
                  children: [
                    // Game status
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Current Turn: ${gameState.currentPlayer.name}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Cards in deck: ${gameState.deck.remainingCards}/${widget.maxCardNumber}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Current Scores
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: gameState.players.map((player) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: player == gameState.currentPlayer 
                                    ? const Color(0xFF00d4ff).withOpacity(0.2)
                                    : Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: player == gameState.currentPlayer 
                                      ? const Color(0xFF00d4ff)
                                      : Colors.white.withOpacity(0.3),
                                  width: player == gameState.currentPlayer ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        player.isHuman ? Icons.person : Icons.android,
                                        size: 18,
                                        color: player.isHuman ? const Color(0xFF00d4ff) : const Color(0xFF4CAF50),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        player.name,
                                        style: TextStyle(
                                          fontWeight: player == gameState.currentPlayer 
                                              ? FontWeight.bold 
                                              : FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Score: ${player.score}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            )).toList(),
                          ),
                          if (gameState.lastAction != null) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00d4ff).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                gameState.lastAction!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    
                    // Table cards area
                    Container(
                      height: 140,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Table Cards',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              if (gameState.tableCards.isNotEmpty) ...[
                                const SizedBox(width: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF00d4ff).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Sum: ${gameState.tableCards.fold(0, (sum, card) => sum + (card.value ?? 0))}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: gameState.tableCards.isEmpty
                                ? Center(
                                    child: Text(
                                      'No cards on table',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.6),
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: gameState.tableCards.length,
                                    itemBuilder: (context, index) {
                                      final card = gameState.tableCards[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
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
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Your Hand',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF00d4ff).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFF00d4ff),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    'Score: ${gameState.players[0].score}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            
                            // Robot thinking indicator (small, integrated)
                            if (gameState.currentPlayer.isRobot)
                              Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFF4CAF50).withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.android, color: Color(0xFF4CAF50), size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${gameState.currentPlayer.name} is thinking...',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF4CAF50),
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            
                            Expanded(
                              child: PlayerHand(
                                cards: gameState.players[0].hand,
                                onCardTap: gameState.currentPlayer.isHuman ? _onCardTap : null,
                                isCurrentPlayer: gameState.currentPlayer.isHuman,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    
                  ],
                ),
              ),
      ),
    );
  }
}