import 'package:flutter/material.dart';
import '../models/applicant_profile.dart';
import 'results_screen.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ieltsController = TextEditingController();
  final TextEditingController _gpaController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  
  String _selectedMajor = 'Computer Science';
  final List<String> _majors = [
    'Computer Science', 'Engineering', 'Business', 
    'Medicine', 'Arts', 'Physics', 'International Relations'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Text(
                  '🍈 MelonUni',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9AAB89),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Find your best university match',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                
                // IELTS Input
                _buildLabel('IELTS Score'),
                TextFormField(
                  controller: _ieltsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'e.g. 7.0',
                    prefixIcon: Icon(Icons.language),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter score';
                    double? v = double.tryParse(value);
                    if (v == null || v < 0 || v > 9) return 'Invalid IELTS score';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // GPA Input
                _buildLabel('GPA (4.0 Scale)'),
                TextFormField(
                  controller: _gpaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'e.g. 3.5',
                    prefixIcon: Icon(Icons.grade),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter GPA';
                    double? v = double.tryParse(value);
                    if (v == null || v < 0 || v > 4.0) return 'Invalid GPA';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Budget Input
                _buildLabel('Annual Budget (USD)'),
                TextFormField(
                  controller: _budgetController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'e.g. 5000',
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter budget';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Major Dropdown
                _buildLabel('Intended Major'),
                DropdownButtonFormField<String>(
                  initialValue: _selectedMajor,
                  items: _majors.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                  onChanged: (val) => setState(() => _selectedMajor = val!),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.school),
                  ),
                ),
                const SizedBox(height: 40),

                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: const Text(
                    'Calculate Chances',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2D3328),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final profile = ApplicantProfile(
        ieltsScore: double.parse(_ieltsController.text),
        gpa: double.parse(_gpaController.text),
        homeCountry: 'Unknown', // Simplified for now
        intendedMajor: _selectedMajor,
        budget: int.parse(_budgetController.text),
        preferredCountries: [], // Can add selector later
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultsScreen(profile: profile),
        ),
      );
    }
  }
}
