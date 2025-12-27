import 'package:flutter/material.dart';
import '../models/applicant_profile.dart';

import '../data/repository.dart';
import '../logic/melon_score_calculator.dart';
import '../widgets/university_card.dart';
import 'details_screen.dart';
import '../logic/openrouter_service.dart';

class ResultsScreen extends StatelessWidget {
  final ApplicantProfile profile;

  const ResultsScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final universities = UniversityRepository().getUniversities();
    
    // Calculate scores and sort
    final scoredUnis = universities.map((uni) {
      final score = MelonScoreCalculator.calculateScore(uni, profile);
      return MapEntry(uni, score);
    }).toList();

    scoredUnis.sort((a, b) => b.value.compareTo(a.value)); // Descending score

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Results'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showGeneralAdvice(context, profile),
        backgroundColor: const Color(0xFF2D3328),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.auto_awesome),
        label: const Text('AI Advisor'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: scoredUnis.length,
        itemBuilder: (context, index) {
          final entry = scoredUnis[index];
          return UniversityCard(
            university: entry.key,
            score: entry.value,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailsScreen(
                    university: entry.key,
                    score: entry.value,
                    profile: profile,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showGeneralAdvice(BuildContext context, ApplicantProfile profile) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final service = OpenRouterService();
      final advice = await service.analyzeProfile(profile: profile);

      if (context.mounted) {
        Navigator.pop(context); // Close loader
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.auto_awesome, color: Color(0xFF9AAB89)),
                SizedBox(width: 8),
                Text('Melon Advisor'),
              ],
            ),
            content: SingleChildScrollView(
              child: Text(advice),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Thanks'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}
