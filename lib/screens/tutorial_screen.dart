import 'package:flutter/material.dart';
import '../widgets/tutorial_overlay.dart';
import '../widgets/card_widget.dart';
import '../models/card.dart';
import '../utils/prime_checker.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  bool showTutorial = true;
  List<NumbaCard> demoTableCards = [];
  List<NumbaCard> demoHand = [];
  int demoSum = 0;
  
  @override
  void initState() {
    super.initState();
    _initializeDemoCards();
  }

  void _initializeDemoCards() {
    // Demo hand with example cards
    demoHand = [
      NumbaCard(value: 2, type: CardType.number, id: 'demo_2'),
      NumbaCard(value: 4, type: CardType.number, id: 'demo_4'),
      NumbaCard(value: 6, type: CardType.number, id: 'demo_6'),
      NumbaCard(value: 3, type: CardType.number, id: 'demo_3'),
      NumbaCard(value: 1, type: CardType.number, id: 'demo_1'),
    ];
    
    // Start with one card on table
    demoTableCards = [
      NumbaCard(value: 5, type: CardType.number, id: 'demo_5'),
    ];
    demoSum = 5;
  }

  List<TutorialStep> get tutorialSteps => [
    TutorialStep(
      title: 'Welcome to Numba!',
      description: 'Numba is a strategic card game where you compete against AI players to collect the most cards. The key to winning is understanding prime numbers!',
      customContent: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF00d4ff).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF00d4ff).withOpacity(0.3)),
        ),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.lightbulb, color: Color(0xFF00d4ff), size: 20),
                SizedBox(width: 8),
                Text(
                  'Prime Numbers Reminder',
                  style: TextStyle(
                    color: Color(0xFF00d4ff),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Prime numbers are numbers that can only be divided by 1 and themselves.\nExamples: 2, 3, 5, 7, 11, 13, 17, 19, 23, 29...',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    ),
    
    TutorialStep(
      title: 'Game Setup',
      description: 'Each player starts with cards from a deck (1-25, 1-40, or 1-50). You take turns playing one card to the center table. Your goal is to make the sum of all table cards equal to a prime number!',
      customContent: _buildDemoGameArea(showCards: false),
    ),
    
    TutorialStep(
      title: 'Your Hand',
      description: 'These are your cards. You can see their values and plan your strategy. Each turn, you must play exactly one card from your hand to the table.',
      customContent: _buildDemoGameArea(showCards: true, highlightHand: true),
    ),
    
    TutorialStep(
      title: 'The Table',
      description: 'Cards played by all players appear on the table. The sum of all table cards is calculated automatically. Watch this sum carefully - it\'s the key to scoring!',
      customContent: _buildDemoGameArea(showCards: true, highlightTable: true),
    ),
    
    TutorialStep(
      title: 'Scoring with Primes',
      description: 'When you play a card that makes the table sum equal to a prime number, you collect ALL cards from the table! Each card you collect adds to your final score.',
      customContent: _buildInteractiveDemo(),
    ),
    
    TutorialStep(
      title: 'Special Rule: Non-Prime Cards',
      description: 'If the table sum is already prime when it\'s your turn, you MUST play a non-prime card (like 1, 4, 6, 8, 9, 10, etc.). This prevents you from immediately collecting cards someone else set up.',
      customContent: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.warning, color: Colors.orange, size: 20),
                SizedBox(width: 8),
                Text(
                  'Important Rule',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Non-prime numbers: 1, 4, 6, 8, 9, 10, 12, 14, 15, 16, 18, 20, 21, 22...',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    ),
    
    TutorialStep(
      title: 'Winning Strategy',
      description: 'The player with the highest score (sum of all collected cards) wins! Plan ahead, watch your opponents, and use your cards strategically to create prime sums.',
      customContent: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF4CAF50).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.tips_and_updates, color: Color(0xFF4CAF50), size: 20),
                SizedBox(width: 8),
                Text(
                  'Pro Tips',
                  style: TextStyle(
                    color: Color(0xFF4CAF50),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '• Save high-value cards for prime opportunities\n'
              '• Watch opponents\' moves to predict their strategy\n'
              '• Try to force opponents to help you create primes\n'
              '• Remember: 2 is the smallest prime number!',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    ),
    
    TutorialStep(
      title: 'Ready to Play!',
      description: 'You now know everything you need to play Numba! The game will guide you with hints and highlights. Good luck and have fun!',
      customContent: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00d4ff), Color(0xFF0099cc)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Column(
          children: [
            Icon(Icons.celebration, color: Colors.white, size: 32),
            SizedBox(height: 8),
            Text(
              'Tutorial Complete!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Time to put your knowledge to the test',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    ),
  ];

  Widget _buildDemoGameArea({
    bool showCards = true, 
    bool highlightHand = false, 
    bool highlightTable = false
  }) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: (highlightTable || highlightHand)
            ? const Color(0xFF00d4ff).withOpacity(0.2)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (highlightTable || highlightHand)
              ? const Color(0xFF00d4ff) 
              : Colors.white.withOpacity(0.1),
          width: (highlightTable || highlightHand) ? 2 : 1,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Table Cards Section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Table Cards',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                if (showCards) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00d4ff).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Sum: $demoSum',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 4),
            if (showCards)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: demoTableCards.map((card) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: CardWidget(
                      card: card,
                      size: CardSize.small,
                    ),
                  )).toList(),
                ),
              )
            else
              Container(
                width: 30,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.credit_card,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            
            const SizedBox(height: 8),
            
            // Your Hand Section
            const Text(
              'Your Hand',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            if (showCards)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: demoHand.map((card) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: CardWidget(
                      card: card,
                      size: CardSize.small,
                    ),
                  )).toList(),
                ),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: Container(
                    width: 25,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                )),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractiveDemo() {
    return StatefulBuilder(
      builder: (context, setDemoState) {
        bool hasTriedDemo = false;
        
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Try it! Current table sum is $demoSum. Tap a card to make it prime:',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              
              // Interactive demo
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: demoHand.map((card) {
                    final newSum = demoSum + (card.value ?? 0);
                    final isPrime = PrimeChecker.isPrime(newSum);
                    
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: GestureDetector(
                        onTap: () {
                          setDemoState(() {
                            hasTriedDemo = true;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isPrime ? const Color(0xFF4CAF50) : Colors.white.withOpacity(0.3),
                              width: isPrime ? 2 : 1,
                            ),
                            color: isPrime 
                                ? const Color(0xFF4CAF50).withOpacity(0.2)
                                : Colors.transparent,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(1),
                            child: CardWidget(
                              card: card,
                              size: CardSize.small,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              
              const SizedBox(height: 6),
              
              // Hint
              if (!hasTriedDemo)
                Text(
                  'Hint: Look for green borders - those cards will make a prime sum!',
                  style: TextStyle(
                    color: const Color(0xFF4CAF50).withOpacity(0.8),
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                )
              else
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Great! Playing cards with green borders will make prime sums and let you collect all table cards.',
                    style: TextStyle(
                      color: Color(0xFF4CAF50),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
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
        child: Column(
          children: [
            // Upper half - Background content (preview of game)
            Expanded(
              flex: 1,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      const Text(
                        'Tutorial Mode',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      // Compact demo area
                      Container(
                        height: 200, // Reduced height
                        margin: const EdgeInsets.only(bottom: 12),
                        child: _buildDemoGameArea(showCards: true),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Lower half - Tutorial overlay
            if (showTutorial)
              Expanded(
                flex: 1,
                child: TutorialOverlay(
                  steps: tutorialSteps,
                  onComplete: () {
                    Navigator.of(context).pop('completed');
                  },
                  onSkip: () {
                    Navigator.of(context).pop('skipped');
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}