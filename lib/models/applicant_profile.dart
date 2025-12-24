class ApplicantProfile {
  final double ieltsScore;
  final double gpa;
  final String homeCountry;
  final String intendedMajor;
  final int budget;
  final List<String> preferredCountries;

  ApplicantProfile({
    required this.ieltsScore,
    required this.gpa,
    required this.homeCountry,
    required this.intendedMajor,
    required this.budget,
    required this.preferredCountries,
  });

  @override
  String toString() {
    return 'IELTS: $ieltsScore, GPA: $gpa, Budget: $budget';
  }
}
