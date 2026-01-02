import 'package:flutter/material.dart';

class ProductivityScoreWidget extends StatelessWidget {
  final int score;

  const ProductivityScoreWidget({super.key, required this.score});

  Color _getScoreColor() {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    if (score >= 40) return Colors.deepOrange;
    return Colors.red;
  }

  String _getScoreLabel() {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Fair';
    return 'Needs Improvement';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Productivity Score',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: score / 100,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(_getScoreColor()),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '$score',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: _getScoreColor(),
                      ),
                    ),
                    Text(
                      '/ 100',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _getScoreLabel(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: _getScoreColor(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

