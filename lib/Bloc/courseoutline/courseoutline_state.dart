part of 'courseoutline_bloc.dart';

@immutable
sealed class CourseoutlineState {}

final class CourseoutlineInitial extends CourseoutlineState {}

final class CourseoutlineLoading extends CourseoutlineState {}

final class CourseoutlineLoaded extends CourseoutlineState {
  final Course course;
  CourseoutlineLoaded(this.course);
}

final class CourseoutlineError extends CourseoutlineState {
  final String message;
  CourseoutlineError(this.message);
}
