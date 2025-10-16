import 'package:flutter/material.dart';
import 'package:wessQuizyy/Service/auth_service.dart';
import 'package:wessQuizyy/Service/game_service.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _QuizState();
}

class _QuizState extends State<HomePage> {

  // Services
  final authService = AuthService();
  final gameService = GameService();

  // Logout
  void handleLogout(BuildContext context) async {
    try {
      await authService.signOut();
    } catch (err) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $err")));
      }
    }
  }

  // Topics
  @override
  void initState() {
    super.initState();
    loadTopics();
  }

  // Fetch topics from service
  bool isLoading = true;
  List<Map<String, dynamic>> topics = [];
  void loadTopics() async {
    setState(() {
      isLoading = true;
    });
    try {
      final fetchedTopics = await gameService.getTopics();
      if(mounted) {
        setState(() {
          topics = fetchedTopics;
        });
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load topics: $error"))
        );
      }
    } finally {
      if(mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void loadTopicQuestions(String topicId) async {
    try {
      final questions = await gameService.getTopicQuestions(topicId);
      if(questions.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No questions available for this topic."))
          );
        }
        return;
      }
      if (!mounted) return;
      Navigator.pushNamed(
        context,
      '/game', 
      arguments: {
        'topicId': topicId,
        'questions': questions,
      });
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load questions: $error"))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //-----> AppBar
      appBar: AppBar(
        elevation: 4,
        backgroundColor: Color(0xFF0a1653),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage('https://api.dicebear.com/9.x/fun-emoji/png?seed=ahmed'),
                fit: BoxFit.cover,
              ),
              ),
            ),
            SizedBox(width: 8),
            Text(
              'Osama',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 21,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: ElevatedButton.icon(
              onPressed: () => handleLogout(context),
              label: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4e75ff),
                shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ],
      ),
      
      //-----> Footer
      bottomNavigationBar: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Color(0xFF0a1653),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, -1),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'wessQuizyy',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      
      //-----> Body
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Choose a Topic',
                  style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0a1653),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : topics.isEmpty
                    ? Center(child: Text('No topics available'))
                    : Column(
                        children: topics.map((topic) {
                          return TopicBox(
                            id: topic['id'].toString(),
                            title: topic['title'] ?? 'No Title',
                            description: topic['description'] ?? 'No Description',
                            iconData: topic['icon'] ?? 'quiz',
                            click: () => loadTopicQuestions(topic['id'].toString()),
                          );
                        }).toList(),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}

class TopicBox extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final String iconData;
  final VoidCallback click;


  const TopicBox({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    required this.iconData,
    required this.click,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF4e75ff).withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: click,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFF4e75ff).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.quiz,
                    color: Color(0xFF4e75ff),
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0a1653),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF4e75ff),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}