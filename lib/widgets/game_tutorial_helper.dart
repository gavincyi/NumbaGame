import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../utils/prime_checker.dart';

class GameTutorialHelper extends StatefulWidget {
  final GameState gameState;
  final VoidCallback? onDismiss;

  const GameTutorialHelper({
    super.key,
    required this.gameState,
    this.onDismiss,
  });

  @override
  State<GameTutorialHelper> createState() => _GameTutorialHelperState();
}

class _GameTutorialHelperState extends State<GameTutorialHelper> {
  bool _showHints = true;
  int _hintsShown = 0;
  
  @override
  Widget build(BuildContext context) {
    if (!_showHints) return const SizedBox();
    
    final hint = _getCurrentHint();
    if (hint == null) return const SizedBox();
    
    return Container(
      margin: const EdgeInsets.only(top: 120, left: 16, right: 16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4CAF50).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.lightbulb,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Tutorial Hint',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _showHints = false;
                    });
                    widget.onDismiss?.call();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 18,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              hint,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hint ${_hintsShown + 1}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _hintsShown++;
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    backgroundColor: Colors.white.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Got it!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String? _getCurrentHint() {
    // Show different hints based on game state and progression
    if (_hintsShown == 0 && widget.gameState.currentPlayer.isHuman) {
      return "It's your turn! Look at the table sum and choose a card that will make it prime. Prime numbers are: 2, 3, 5, 7, 11, 13, 17, 19, 23...";
    }
    
    if (_hintsShown == 1 && widget.gameState.tableCards.isNotEmpty) {
      final currentSum = widget.gameState.tableCards.fold(0, (sum, card) => sum + (card.value ?? 0));
      final humanPlayer = widget.gameState.players.firstWhere((p) => p.isHuman);
      
      // Find cards that would make prime sums
      final primeCards = humanPlayer.hand.where((card) {
        final newSum = currentSum + (card.value ?? 0);
        return PrimeChecker.isPrime(newSum);
      }).toList();
      
      if (primeCards.isNotEmpty) {
        return "Great! You have cards that can make prime sums. Look for the green highlights on cards when it's your turn - those will let you collect all table cards!";
      } else {
        return "No prime opportunities right now. Play a card strategically to set up future moves, or wait for the right moment.";
      }
    }
    
    if (_hintsShown == 2 && widget.gameState.requiresNonPrimeCard) {
      return "The table sum is already prime! You must play a non-prime card (like 1, 4, 6, 8, 9, 10, 12...) to avoid helping other players.";
    }
    
    if (_hintsShown == 3) {
      return "Watch how the AI players make their moves. They're trying to create prime sums too! Try to anticipate their strategy.";
    }
    
    if (_hintsShown == 4) {
      return "Pro tip: Sometimes it's better to play a high card when you can't make a prime, forcing opponents to deal with a higher sum.";
    }
    
    if (_hintsShown >= 5) {
      return "You're getting the hang of it! The tutorial hints will stop showing now. Good luck!";
    }
    
    return null;
  }
}