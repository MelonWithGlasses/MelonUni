class University {
  final String name;
  final String country;
  final double minIelts;
  final double minGpa;
  final int tuition;
  final List<String> scholarships;
  final double difficulty; // 0.0 to 1.0 (1.0 = highly competitive)
  final List<String> supportedMajors;

  const University({
    required this.name,
    required this.country,
    required this.minIelts,
    required this.minGpa,
    required this.tuition,
    required this.scholarships,
    required this.difficulty,
    required this.supportedMajors,
  });
}
