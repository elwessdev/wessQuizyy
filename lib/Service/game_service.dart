import 'dart:ffi';

import 'package:supabase_flutter/supabase_flutter.dart';

class GameService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get Topics
  Future<List<Map<String, dynamic>>> getTopics() async {
    try {
      final response = await _supabase.from('topics').select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to load topics: $e');
    }
  }

  // Get Topic Questions
  Future<List<Map<String, dynamic>>> getTopicQuestions(String topicId) async {
    try {
      final response = await _supabase
          .from('questions')
          .select()
          .eq('topic_id', topicId);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to load questions: $e');
    }
  }
}