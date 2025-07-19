import 'package:flutter/material.dart';
import '../models/game_state.dart';

class PlayHistoryDialog extends StatelessWidget {
  final List<PlayHistoryEntry> playHistory;

  const PlayHistoryDialog({
    super.key,
    required this.playHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Play History',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (playHistory.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    'No moves yet. Start playing to see the history!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: playHistory.length,
                  itemBuilder: (context, index) {
                    final entry = playHistory[index];
                    final moveNumber = index + 1;
                    
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: entry.isPrime ? Colors.green : Colors.blue,
                          child: Text(
                            moveNumber.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          entry.playerName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(entry.description),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                _buildInfoChip(
                                  'Card: ${entry.card.displayName}',
                                  Colors.blue.shade100,
                                ),
                                const SizedBox(width: 8),
                                _buildInfoChip(
                                  'Sum: ${entry.tableSum}',
                                  entry.isPrime ? Colors.green.shade100 : Colors.grey.shade100,
                                ),
                                if (entry.cardsCollected > 0) ...[
                                  const SizedBox(width: 8),
                                  _buildInfoChip(
                                    'Collected: ${entry.cardsCollected}',
                                    Colors.orange.shade100,
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Score: ${entry.playerScore} | ${_formatTime(entry.timestamp)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        trailing: entry.isPrime
                            ? Icon(
                                Icons.star,
                                color: Colors.amber.shade600,
                              )
                            : null,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}';
  }
}