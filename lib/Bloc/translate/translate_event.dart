part of 'translate_bloc.dart';

@immutable
sealed class TranslateEvent {}

class TranslateText extends TranslateEvent {
  final String targetLanguage;
  TranslateText(this.targetLanguage);
}
