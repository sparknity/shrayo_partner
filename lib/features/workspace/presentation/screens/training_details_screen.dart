import 'package:flutter/material.dart';
import 'course_details_screen.dart';

/// Training Details screen (`/workspace/training/:id`) matching `Course Details.png`.
class TrainingDetailsScreen extends StatelessWidget {
  final String id;

  const TrainingDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return CourseDetailsScreen(id: id, courseId: id);
  }
}
