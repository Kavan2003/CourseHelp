part of 'courseoutline_bloc.dart';

sealed class CourseoutlineEvent {}

class GenerateCourseOutline extends CourseoutlineEvent {
  final String title;
  final String description;
  GenerateCourseOutline(this.title, this.description);
}

class EditCourseOutline extends CourseoutlineEvent {
  final Course course;
  EditCourseOutline(this.course);
}

class ManualCourseOutline extends CourseoutlineEvent {
  final String title;
  final String description;
  ManualCourseOutline(this.title, this.description);
}
