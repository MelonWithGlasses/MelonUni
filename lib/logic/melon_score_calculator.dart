import 'dart:math';
import '../models/university.dart';
import '../models/applicant_profile.dart';

class MelonScoreCalculator {
  /// Returns a probability between 0.0 and 1.0
  static double calculateScore(University uni, ApplicantProfile profile) {
    double score = 0.5; // Base score

    // 1. IELTS Impact
    if (profile.ieltsScore >= uni.minIelts) {
      double diff = profile.ieltsScore - uni.minIelts;
      score += 0.1 + (diff * 0.15); // Base bonus + extra for higher score
    } else {
      double diff = uni.minIelts - profile.ieltsScore;
      score -= 0.2 + (diff * 0.2); // Penalty for low score
    }

    // 2. GPA Impact
    if (profile.gpa >= uni.minGpa) {
      double diff = profile.gpa - uni.minGpa;
      score += 0.1 + (diff * 0.2);
    } else {
      // Small penalty if close, large if far
      double diff = uni.minGpa - profile.gpa;
      score -= (diff * 0.3);
    }

    // 3. Educational Budget
    if (uni.tuition == 0 || profile.budget >= uni.tuition) {
      score += 0.1;
    } else {
      // Can't afford? Partial penalty (maybe scholarships help)
      score -= 0.15;
    }

    // 4. Difficulty Penalty
    score -= (uni.difficulty * 0.3);

    // 5. Country Preference match
    if (profile.preferredCountries.contains(uni.country)) {
      score += 0.05;
    }

    // Clamp between 5% and 98%
    return max(0.05, min(0.98, score));
  }

  static String getCategory(double score) {
    if (score >= 0.75) return 'Safe';
    if (score >= 0.40) return 'Possible';
    return 'Hard';
  }

  static String getImprovementTip(University uni, ApplicantProfile profile) {
    List<String> tips = [];
    if (profile.ieltsScore <= uni.minIelts + 0.5) {
      tips.add('Increase IELTS to ${uni.minIelts + 0.5} (+15%)');
    }
    if (profile.gpa <= uni.minGpa + 0.2) {
      tips.add('Improve GPA to ${(uni.minGpa + 0.2).toStringAsFixed(1)} (+10%)');
    }
    if (tips.isEmpty) {
      return 'Maintain current performance.';
    }
    return tips.first;
  }
}
