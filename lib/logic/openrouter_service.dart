import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/applicant_profile.dart';
import '../models/university.dart';

class OpenRouterService {
  static const String _baseUrl = 'https://openrouter.ai/api/v1/chat/completions';
  static const String _model = 'google/gemma-3-27b-it:free';

  Future<String> analyzeProfile({
    required ApplicantProfile profile,
    University? university,
  }) async {
    final apiKey = dotenv.env['OPENROUTER_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      return 'Error: API Key not found.';
    }

    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    String prompt;
    if (university != null) {
      // University specific analysis
      prompt = _buildUniversityPrompt(profile, university);
    } else {
      // General advice
      prompt = _buildGeneralPrompt(profile);
    }

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: headers,
        body: jsonEncode({
          'model': _model,
          'messages': [
            {
              'role': 'system',
              'content': 'You are MelonUni, an expert university admission counselor. '
                  'Your goal is to help students get into universities by providing '
                  'honest, concise, and constructive feedback. '
                  'Keep responses short (under 150 words) and actionable.'
            },
            {'role': 'user', 'content': prompt}
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        return 'Error: AI Server returned ${response.statusCode}';
      }
    } catch (e) {
      return 'Connection Error: $e';
    }
  }

  String _buildUniversityPrompt(ApplicantProfile profile, University uni) {
    return '''
    Analyze my admission chances for:
    University: ${uni.name} (${uni.country})
    Requirements: IELTS ${uni.minIelts}, GPA ${uni.minGpa}, Difficulty: ${(uni.difficulty * 10).toInt()}/10
    
    My Profile:
    IELTS: ${profile.ieltsScore}
    GPA: ${profile.gpa}
    Major: ${profile.intendedMajor}
    Budget: \$${profile.budget} vs Tuition: \$${uni.tuition}
    
    1. Calculate my probability (High/Medium/Low).
    2. Explain the main problem given my stats.
    3. Suggest one concrete way to improve my chances.
    ''';
  }

  String _buildGeneralPrompt(ApplicantProfile profile) {
    return '''
    I need help finding universities.
    My Profile:
    IELTS: ${profile.ieltsScore}
    GPA: ${profile.gpa}
    Major: ${profile.intendedMajor}
    Budget: \$${profile.budget}
    Preferred Countries: ${profile.preferredCountries.join(", ")}
    
    1. Assess my overall profile strength.
    2. Recommend 2-3 specific countries or types of universities I should target.
    3. Give me one key improvement advise.
    ''';
  }
}
