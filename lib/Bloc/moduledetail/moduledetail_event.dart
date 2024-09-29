part of 'moduledetail_bloc.dart';

@immutable
sealed class ModuledetailEvent {}

class GenerateModuleDetail extends ModuledetailEvent {
  final String title;
  final String description;
  final int duration;
  GenerateModuleDetail(this.title, this.description, this.duration);
}
