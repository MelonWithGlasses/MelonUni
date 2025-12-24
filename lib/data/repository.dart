import '../models/university.dart';

class UniversityRepository {
  static const List<University> _universities = [
    University(
      name: 'Tsinghua University',
      country: 'China',
      minIelts: 6.5,
      minGpa: 3.5,
      tuition: 0, // Often covered by CSC
      scholarships: ['CSC Scholarship', 'Beijing Govt Scholarship'],
      difficulty: 0.9,
      supportedMajors: ['Computer Science', 'Engineering', 'Physics'],
    ),
    University(
      name: 'KBTU',
      country: 'Kazakhstan',
      minIelts: 5.5,
      minGpa: 3.0,
      tuition: 4000,
      scholarships: ['Merit Scholarship', 'Internal Grant'],
      difficulty: 0.4,
      supportedMajors: ['IT', 'Oil & Gas', 'Business'],
    ),
    University(
      name: 'KAIST',
      country: 'South Korea',
      minIelts: 7.0,
      minGpa: 3.8,
      tuition: 0,
      scholarships: ['GKS', 'KAIST Scholarship'],
      difficulty: 0.95,
      supportedMajors: ['Robotics', 'AI', 'CS'],
    ),
    University(
      name: 'Warsaw University of Technology',
      country: 'Poland',
      minIelts: 6.0,
      minGpa: 3.2,
      tuition: 3000,
      scholarships: ['Poland Gov Scholarship'],
      difficulty: 0.6,
      supportedMajors: ['Architecture', 'Engineering'],
    ),
    University(
      name: 'METU (Middle East Technical Univ)',
      country: 'Turkey',
      minIelts: 6.0,
      minGpa: 3.0,
      tuition: 1500,
      scholarships: ['Turkiye Burslari'],
      difficulty: 0.55,
      supportedMajors: ['Engineering', 'International Relations'],
    ),
     University(
      name: 'Technical University of Munich',
      country: 'Germany',
      minIelts: 7.0,
      minGpa: 3.7,
      tuition: 0, // Public univs mostly free
      scholarships: ['DAAD'],
      difficulty: 0.85,
      supportedMajors: ['Informatics', 'Mechanical Engineering'],
    ),
  ];

  List<University> getUniversities() {
    return _universities;
  }
}
