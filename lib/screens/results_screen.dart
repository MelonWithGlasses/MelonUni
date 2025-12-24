import 'package:flutter/material.dart';
import '../models/applicant_profile.dart';

import '../data/repository.dart';
import '../logic/melon_score_calculator.dart';
import '../widgets/university_card.dart';
import 'details_screen.dart';

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
}
