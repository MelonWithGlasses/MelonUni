import 'package:flutter/material.dart';
import '../models/university.dart';
import '../models/applicant_profile.dart';
import '../logic/melon_score_calculator.dart';
import '../logic/openrouter_service.dart';

class DetailsScreen extends StatelessWidget {
  final University university;
  final double score;
  final ApplicantProfile profile;

  const DetailsScreen({
    super.key,
    required this.university,
    required this.score,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final tip = MelonScoreCalculator.getImprovementTip(university, profile);
    final category = MelonScoreCalculator.getCategory(score);
    final color = _getColorForCategory(category);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF8),
      appBar: AppBar(
        title: Text(university.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Admission Probability',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${(score * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Improvement Tips
            if (score < 0.8) ...[
              const Text(
                '🚀 How to Improve',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3328),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD95A).withValues(alpha: 0.2), // Yellow tint
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFFD95A)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb, color: Color(0xFFD4A017)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        tip,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF5A4D20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],



            // AI Advisor Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _showAIAdvice(context),
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Ask AI Advisor'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D3328),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Details
            const Text(
              'University Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3328),
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.location_on, 'Country', university.country),
            _buildDetailRow(Icons.money, 'Tuition', '\$${university.tuition}/year'),
            _buildDetailRow(Icons.grade, 'Min GPA', university.minGpa.toString()),
            _buildDetailRow(Icons.language, 'Min IELTS', university.minIelts.toString()),
            
            const SizedBox(height: 32),
            const Text(
              'Scholarships',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3328),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: university.scholarships.map((s) => Chip(
                label: Text(s),
                backgroundColor: const Color(0xFF9AAB89).withValues(alpha: 0.1),
                labelStyle: const TextStyle(color: Color(0xFF2D3328)),
              )).toList(),
            ),
            
            const SizedBox(height: 32),
             const Text(
              'Majors',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3328),
              ),
            ),
            const SizedBox(height: 16),
             Wrap(
              spacing: 8,
              runSpacing: 8,
              children: university.supportedMajors.map((s) => Chip(
                label: Text(s),
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
              )).toList(),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3328),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'Safe':
        return Colors.green;
      case 'Possible':
        return const Color(0xffd4a017);
      case 'Hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _showAIAdvice(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final service = OpenRouterService();
      final advice = await service.analyzeProfile(
        profile: profile,
        university: university,
      );

      if (context.mounted) {
        Navigator.pop(context); // Close loader
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.auto_awesome, color: Color(0xFF9AAB89)),
                SizedBox(width: 8),
                Text('AI Advisor says:'),
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
          SnackBar(content: Text('Failed to get advice: $e')),
        );
      }
    }
  }
}
