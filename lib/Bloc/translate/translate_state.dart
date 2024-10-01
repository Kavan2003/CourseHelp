part of 'translate_bloc.dart';

@immutable
sealed class TranslateState {}

final class TranslateInitial extends TranslateState {}

final class TranslateLoading extends TranslateState {}

final class TranslateLoaded extends TranslateState {
  final Course translatedTextCourse;
  final List<Lessons> translatedTextLesson;
  TranslateLoaded(this.translatedTextCourse, this.translatedTextLesson);
}

final class TranslateError extends TranslateState {
  final String message;
  TranslateError(this.message);
}
