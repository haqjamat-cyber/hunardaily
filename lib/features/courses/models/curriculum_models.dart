import 'dart:convert';

class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.prompts,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    final rawPrompts = json['prompt'] as Map<String, dynamic>;
    final prompts = rawPrompts.map(
      (key, value) => MapEntry<String, String>(key, value.toString()),
    );
    final rawOptions = json['options'] as List<dynamic>;
    return QuizQuestion(
      id: json['id'] as String,
      prompts: prompts,
      options: rawOptions.map((e) => e.toString()).toList(growable: false),
      correctIndex: json['correctIndex'] as int,
      explanation: json['explanation'] as String,
    );
  }

  final String id;
  final Map<String, String> prompts;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  String promptForPair(String learningPairCode) {
    return prompts[learningPairCode] ??
        prompts['default'] ??
        (prompts.values.isNotEmpty ? prompts.values.first : '');
  }
}

class CourseLevel {
  const CourseLevel({
    required this.id,
    required this.name,
    required this.questions,
  });

  factory CourseLevel.fromJson(Map<String, dynamic> json) {
    final rawQuestions = json['questions'] as List<dynamic>;
    return CourseLevel(
      id: json['id'] as String,
      name: json['name'] as String,
      questions: rawQuestions
          .map((q) => QuizQuestion.fromJson(q as Map<String, dynamic>))
          .toList(growable: false),
    );
  }

  final String id;
  final String name;
  final List<QuizQuestion> questions;
}

class CourseModule {
  const CourseModule({
    required this.id,
    required this.title,
    required this.levels,
  });

  factory CourseModule.fromJson(Map<String, dynamic> json) {
    final rawLevels = json['levels'] as List<dynamic>;
    return CourseModule(
      id: json['id'] as String,
      title: json['title'] as String,
      levels: rawLevels
          .map((l) => CourseLevel.fromJson(l as Map<String, dynamic>))
          .toList(growable: false),
    );
  }

  final String id;
  final String title;
  final List<CourseLevel> levels;
}

class CurriculumCatalog {
  const CurriculumCatalog({
    required this.version,
    required this.courses,
  });

  factory CurriculumCatalog.fromJsonString(String jsonStr) {
    final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
    final rawCourses = decoded['courses'] as List<dynamic>;
    return CurriculumCatalog(
      version: decoded['version'] as int,
      courses: rawCourses
          .map((c) => CourseModule.fromJson(c as Map<String, dynamic>))
          .toList(growable: false),
    );
  }

  final int version;
  final List<CourseModule> courses;

  CourseModule? courseById(String id) {
    for (final course in courses) {
      if (course.id == id) {
        return course;
      }
    }
    return null;
  }
}
