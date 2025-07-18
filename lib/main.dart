import 'package:flutter/material.dart';
import 'screens/game_screen.dart';
import 'services/audio_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AudioService().initialize();
  runApp(const CardGameApp());
}

class CardGameApp extends StatelessWidget {
  const CardGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Numba',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
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
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo/Image Section
                Container(
                  width: isSmallScreen ? screenSize.width * 0.7 : 300,
                  height: isSmallScreen ? screenSize.width * 0.7 : 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      'assets/image/home.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                SizedBox(height: screenSize.height * 0.08),
                
                // Action Buttons
                Container(
                  width: isSmallScreen ? screenSize.width * 0.8 : 320,
                  child: Column(
                    children: [
                      _buildActionButton(
                        context: context,
                        text: 'Start Game',
                        icon: Icons.play_arrow,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const DeckSizeScreen()),
                          );
                        },
                        isPrimary: true,
                      ),
                      const SizedBox(height: 20),
                      _buildActionButton(
                        context: context,
                        text: 'How to Play',
                        icon: Icons.help_outline,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HelpScreen()),
                          );
                        },
                        isPrimary: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: isPrimary 
            ? const LinearGradient(
                colors: [Color(0xFF00d4ff), Color(0xFF0099cc)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        color: isPrimary ? null : Colors.white.withOpacity(0.1),
        border: isPrimary 
            ? null 
            : Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        boxShadow: isPrimary 
            ? [
                BoxShadow(
                  color: const Color(0xFF00d4ff).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: isPrimary ? Colors.white : Colors.white,
                ),
                const SizedBox(width: 12),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isPrimary ? Colors.white : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DeckSizeScreen extends StatelessWidget {
  const DeckSizeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Deck Size',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  SizedBox(height: screenSize.height * 0.05),
                  
                  // Header Section
                  Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.deck,
                          size: isSmallScreen ? 48 : 64,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Choose Your Deck',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 28 : 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Select the highest number in your deck',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 16 : 18,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: screenSize.height * 0.03),
                  
                  // Deck Options
                  Container(
                    width: isSmallScreen ? double.infinity : 500,
                    child: Column(
                      children: [
                        _buildDeckOption(
                          context: context,
                          title: 'Beginner',
                          subtitle: 'Numbers 1-25',
                          description: 'Perfect for new players',
                          icon: Icons.star_border,
                          maxCardNumber: 25,
                          color: const Color(0xFF4CAF50),
                        ),
                        const SizedBox(height: 16),
                        _buildDeckOption(
                          context: context,
                          title: 'Intermediate',
                          subtitle: 'Numbers 1-40',
                          description: 'For experienced players',
                          icon: Icons.star_half,
                          maxCardNumber: 40,
                          color: const Color(0xFFFF9800),
                        ),
                        const SizedBox(height: 16),
                        _buildDeckOption(
                          context: context,
                          title: 'Advanced',
                          subtitle: 'Numbers 1-50',
                          description: 'For expert players',
                          icon: Icons.star,
                          maxCardNumber: 50,
                          color: const Color(0xFFF44336),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: screenSize.height * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeckOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required int maxCardNumber,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlayersScreen(maxCardNumber: maxCardNumber),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withOpacity(0.6),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlayersScreen extends StatelessWidget {
  final int maxCardNumber;
  
  const PlayersScreen({super.key, required this.maxCardNumber});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Players',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  SizedBox(height: screenSize.height * 0.05),
                  
                  // Header Section
                  Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.people,
                          size: isSmallScreen ? 48 : 64,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Choose Players',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 28 : 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Numbers 1-$maxCardNumber',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: screenSize.height * 0.03),
                  
                  // Player Options
                  Container(
                    width: isSmallScreen ? double.infinity : 500,
                    child: Column(
                      children: [
                        _buildPlayerOption(
                          context: context,
                          playerCount: 2,
                          title: '2 Players',
                          subtitle: 'You vs Computer',
                          description: 'Quick and simple game',
                          icon: Icons.person,
                          color: const Color(0xFF4CAF50),
                        ),
                        const SizedBox(height: 16),
                        _buildPlayerOption(
                          context: context,
                          playerCount: 3,
                          title: '3 Players',
                          subtitle: 'You vs 2 Computers',
                          description: 'More challenging gameplay',
                          icon: Icons.people,
                          color: const Color(0xFFFF9800),
                        ),
                        const SizedBox(height: 16),
                        _buildPlayerOption(
                          context: context,
                          playerCount: 4,
                          title: '4 Players',
                          subtitle: 'You vs 3 Computers',
                          description: 'Maximum challenge',
                          icon: Icons.groups,
                          color: const Color(0xFFF44336),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: screenSize.height * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerOption({
    required BuildContext context,
    required int playerCount,
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _startGame(context, playerCount),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withOpacity(0.6),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _startGame(BuildContext context, int players) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(
          playerCount: players,
          maxCardNumber: maxCardNumber,
        ),
      ),
    );
  }
}

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'How to Play',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  SizedBox(height: screenSize.height * 0.03),
                  
                  // Header Section
                  Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.help_outline,
                          size: isSmallScreen ? 48 : 64,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'How to Play',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 28 : 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Learn the rules and strategies',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 16 : 18,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: screenSize.height * 0.03),
                  
                  // Help Content
                  Container(
                    width: isSmallScreen ? double.infinity : 600,
                    child: Column(
                      children: [
                        _buildHelpCard(
                          title: 'Game Overview',
                          content: 'Numba is a strategic card game where players compete to collect the best combination of number cards. The goal is to score the most points by playing cards strategically.',
                          icon: Icons.games,
                          color: const Color(0xFF4CAF50),
                        ),
                        const SizedBox(height: 16),
                        _buildHelpCard(
                          title: 'Getting Started',
                          content: '1. Choose your deck size (1-25, 1-40, or 1-50)\n2. Select number of players (2-4)\n3. Each player receives cards\n4. Take turns playing cards strategically',
                          icon: Icons.play_circle_outline,
                          color: const Color(0xFFFF9800),
                        ),
                        const SizedBox(height: 16),
                        _buildHelpCard(
                          title: 'Scoring System',
                          content: 'Points are awarded based on:\n• Prime numbers: +5 points\n• Even numbers: +2 points\n• Odd numbers: +1 point\n• Special combinations: Bonus points',
                          icon: Icons.star,
                          color: const Color(0xFFF44336),
                        ),
                        const SizedBox(height: 16),
                        _buildHelpCard(
                          title: 'Tips & Strategies',
                          content: '• Save prime numbers for high-scoring plays\n• Watch your opponents\' moves\n• Plan your card combinations\n• Don\'t waste high-value cards early',
                          icon: Icons.lightbulb_outline,
                          color: const Color(0xFF9C27B0),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: screenSize.height * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHelpCard({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              content,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  SizedBox(height: screenSize.height * 0.03),
                  
                  // Header Section
                  Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.settings,
                          size: isSmallScreen ? 48 : 64,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Game Settings',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 28 : 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Customize your gaming experience',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 16 : 18,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: screenSize.height * 0.03),
                  
                  // Settings Content
                  Container(
                    width: isSmallScreen ? double.infinity : 600,
                    child: Column(
                      children: [
                        _buildSettingsCard(
                          title: 'Sound Effects',
                          subtitle: 'Enable or disable game sounds',
                          icon: Icons.volume_up,
                          color: const Color(0xFF4CAF50),
                          trailing: Switch(
                            value: true,
                            onChanged: (value) {
                              // TODO: Implement sound toggle
                            },
                            activeColor: const Color(0xFF4CAF50),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildSettingsCard(
                          title: 'Background Music',
                          subtitle: 'Play music during the game',
                          icon: Icons.music_note,
                          color: const Color(0xFFFF9800),
                          trailing: Switch(
                            value: false,
                            onChanged: (value) {
                              // TODO: Implement music toggle
                            },
                            activeColor: const Color(0xFFFF9800),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildSettingsCard(
                          title: 'Vibration',
                          subtitle: 'Haptic feedback on card selection',
                          icon: Icons.vibration,
                          color: const Color(0xFFF44336),
                          trailing: Switch(
                            value: true,
                            onChanged: (value) {
                              // TODO: Implement vibration toggle
                            },
                            activeColor: const Color(0xFFF44336),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildSettingsCard(
                          title: 'Dark Mode',
                          subtitle: 'Use dark theme throughout the app',
                          icon: Icons.dark_mode,
                          color: const Color(0xFF9C27B0),
                          trailing: Switch(
                            value: false,
                            onChanged: (value) {
                              // TODO: Implement dark mode toggle
                            },
                            activeColor: const Color(0xFF9C27B0),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildSettingsCard(
                          title: 'Game Statistics',
                          subtitle: 'View your game history and stats',
                          icon: Icons.analytics,
                          color: const Color(0xFF2196F3),
                          trailing: IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                            onPressed: () {
                              // TODO: Navigate to statistics screen
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildSettingsCard(
                          title: 'About',
                          subtitle: 'App version and information',
                          icon: Icons.info_outline,
                          color: const Color(0xFF607D8B),
                          trailing: IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                            onPressed: () {
                              // TODO: Navigate to about screen
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: screenSize.height * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget trailing,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
