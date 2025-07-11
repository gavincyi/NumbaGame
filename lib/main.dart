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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Numba Game'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
            ),
            const Text(
              'NUMBA',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 20),
            const Text(
              'A strategic numbers and prime game',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 80),
            
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DeckSizeScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 60),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('Start Game'),
            ),
            
            const SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 60),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('How to Play'),
            ),
          ],
        ),
      ),
    );
  }
}

class DeckSizeScreen extends StatelessWidget {
  const DeckSizeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Deck Size'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select Deck Size',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Choose the highest number in your deck',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 60),
            
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PlayersScreen(maxCardNumber: 25),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(250, 60),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('Numbers 1-25'),
            ),
            
            const SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PlayersScreen(maxCardNumber: 40),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(250, 60),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('Numbers 1-40'),
            ),
            
            const SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PlayersScreen(maxCardNumber: 50),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(250, 60),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('Numbers 1-50'),
            ),
          ],
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Players'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select Number of Players',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Playing with numbers 1-${maxCardNumber}',
              style: const TextStyle(fontSize: 18, color: Colors.blue),
            ),
            const SizedBox(height: 15),
            const Text(
              'You are Player 1, others are computer players',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 60),
            
            ElevatedButton(
              onPressed: () {
                _startGame(context, 2);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(250, 60),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('2 Players'),
            ),
            
            const SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: () {
                _startGame(context, 3);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(250, 60),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('3 Players'),
            ),
            
            const SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: () {
                _startGame(context, 4);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(250, 60),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('4 Players'),
            ),
          ],
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How to Play',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to Numba! Here you can learn how to play and understand the rules.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Game instructions will be added here once you provide more details about the specific card game rules.',
              style: TextStyle(fontSize: 16),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Game Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Settings options will be added here based on your game requirements.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
