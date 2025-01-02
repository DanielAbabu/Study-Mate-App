import 'package:flutter/material.dart';
import '../widgets/flip_card.dart';

class FlipCardDetailScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cards;

  FlipCardDetailScreen({required this.cards});

  @override
  _FlipCardDetailScreenState createState() => _FlipCardDetailScreenState();
}

class _FlipCardDetailScreenState extends State<FlipCardDetailScreen> {
  int currentIndex = 0;

  void nextCard() {
    setState(() {
      currentIndex = (currentIndex + 1);
      if (widget.cards.length == currentIndex){
        currentIndex = currentIndex -1;
      }
    });
  }

  void previousCard() {
    setState(() {
      currentIndex = (currentIndex - 1) ;
      if (currentIndex == -1){
        currentIndex = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentCard = widget.cards[currentIndex];
    final progress = (currentIndex + 1) / widget.cards.length;

    return Scaffold(
      appBar: AppBar(title: Text('Flip Cards')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                color: Colors.blue,
                minHeight: 5.0,
              ),
            ),
            SizedBox(height: 20),
            // Flip Card Widget
            Flip_Card(
              key: ValueKey(currentIndex),
              question: currentCard['question']!,
              answer: currentCard['answer']!,
            ),
            SizedBox(height: 20),
            // Navigation Arrows
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_left, size: 40),
                  onPressed: previousCard,
                ),
                IconButton(
                  icon: Icon(Icons.arrow_right, size: 40),
                  onPressed: nextCard,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
