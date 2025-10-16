
import 'package:flutter/material.dart';
import 'package:wessQuizyy/Service/auth_service.dart';


class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GameState();
}

class _GameState extends State<GamePage> {

  final Map qts = {
    0: {
      "question": "What is Fasts Programming Language?",
      "answers": [
        {"text": "Python", "score": 1},
        {"text": "C++", "score": 3},
        {"text": "C", "score": 4},
      ],
    },
    1: {
      "question": "Best Programming Language for Mobile Apps?",
      "answers": [
        {"text": "Java", "score": 1},
        {"text": "Dart", "score": 4},
        {"text": "Kotlin", "score": 3},
      ],
    },
    2: {
      "question": "Best Programming Language for Web Apps?",
      "answers": [
        {"text": "JavaScript", "score": 4},
        {"text": "PHP", "score": 2},
        {"text": "Python", "score": 3},
      ],
    },
    3: {
      "question": "Best Programming Language for AI?",
      "answers": [
        {"text": "Python", "score": 4},
        {"text": "Java", "score": 2},
        {"text": "C++", "score": 3},
      ],
    },
  };

  int currentQuestionIndex = 0;
  int totalScore = 0;


  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final topicId = args['topicId'];
    final questions = args['questions'];

    print(questions);

    return Scaffold(
      body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text("ee")
    )
    );
  }
}
