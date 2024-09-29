part of 'moduledetail_bloc.dart';

@immutable
sealed class ModuledetailState {}

final class ModuledetailInitial extends ModuledetailState {}

final class ModuledetailLoading extends ModuledetailState {}

final class ModuledetailLoaded extends ModuledetailState {
  final Lessons module;
  ModuledetailLoaded(this.module);
}

final class ModuledetailError extends ModuledetailState {
  final String message;
  ModuledetailError(this.message);
}
