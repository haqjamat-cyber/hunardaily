import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hunardaily/features/courses/models/curriculum_models.dart';

final curriculumProvider = FutureProvider<CurriculumCatalog>((ref) async {
  final rawJson = await rootBundle.loadString('assets/content/curriculum_v1.json');
  return CurriculumCatalog.fromJsonString(rawJson);
});
