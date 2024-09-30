part of 'moduledetail_bloc.dart';

sealed class ModuledetailEvent {}

class GenerateModuleDetail extends ModuledetailEvent {
  final String title;
  final String description;
  final int duration;
  GenerateModuleDetail(this.title, this.description, this.duration);
}

class EditGeneratedModuleDetails extends ModuledetailEvent {
  final Lessons module;
  final String title;
  final String description;
  final int duration;

  EditGeneratedModuleDetails(
      this.module, this.title, this.description, this.duration);
}
