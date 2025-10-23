
import 'package:flutter/material.dart';
import 'package:wessQuizyy/Service/auth_service.dart';


class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GameState();
}

class _GameState extends State<GamePage> {

  late String ID;
  late List questions;
  int currentQuestionIndex = 0;
  int score = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    ID = args['topicId'];
    questions = args['questions'];
  }

  List<Widget> buildOptions() {
    List<Widget> options = [];
    for (var option in questions[currentQuestionIndex]['options']) {
      final bool isMultiple = questions[currentQuestionIndex]['is_multiple'] ?? false;
      
      if (isMultiple) {
        options.add(
          ListTile(
            title: Text(option['text']),
            leading: Checkbox(
              activeColor: Color(0xFF4e75ff),
              checkColor: Colors.white,
              value: option['selected'] ?? false,
              onChanged: (bool? value) {
                setState(() {
                  option['selected'] = value;
                });
              },
            ),
          ),
        );
      } else {
        options.add(
          ListTile(
            title: Text(option['text']),
            leading: Radio(
              value: option,
              groupValue: questions[currentQuestionIndex]['selectedOption'],
              onChanged: (value) {
                setState(() {
                  questions[currentQuestionIndex]['selectedOption'] = value;
                  for (var opt in questions[currentQuestionIndex]['options']) {
                    opt['selected'] = false;
                  }
                  option['selected'] = true;
                });
              },
            ),
          ),
        );
      }
    }
    return options;
  }

  void validateAnswer() {
    final bool isMultiple = questions[currentQuestionIndex]['is_multiple'] ?? false;
    
    if (isMultiple) {
      bool allCorrect = true;
      
      for (var option in questions[currentQuestionIndex]['options']) {
        bool isCorrect = option['correct'] == true;
        bool isSelected = option['selected'] == true;
        if (isCorrect != isSelected) {
          allCorrect = false;
          break;
        }
      }
      
      if (allCorrect) {
        score++;
      }
    } else {
      var selectedOption = questions[currentQuestionIndex]['selectedOption'];
      if (selectedOption != null && selectedOption['correct'] == true) {
        score++;
      }
    }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        backgroundColor: Color(0xFF0a1653),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(
            value: (currentQuestionIndex + 1) / questions.length,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4e75ff)),
          ),
          SizedBox(height: 20),
          Text(
            'Question ${currentQuestionIndex + 1}/${questions.length}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            questions[currentQuestionIndex]['title'],
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 30),
          ...buildOptions(),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (currentQuestionIndex > 0)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentQuestionIndex--;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4e75ff),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Previous',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  if (currentQuestionIndex < questions.length - 1) {
                    setState(() {
                      validateAnswer();
                      currentQuestionIndex++;
                    });
                  } else {
                    validateAnswer();
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Quiz Completed'),
                        content: Text('Your score: $score/${questions.length}'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4e75ff),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  currentQuestionIndex < questions.length - 1 ? 'Next' : 'Finish',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      )
    )
    );
  }
}
