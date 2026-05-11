part of 'set_initial_level_cubit.dart';

abstract class SetInitialLevelState {}

class SetInitialLevelInitial extends SetInitialLevelState {}

class SetInitialLevelLoading extends SetInitialLevelState {}

class SetInitialLevelSuccess extends SetInitialLevelState {
  final int allowedLevel;

  SetInitialLevelSuccess({required this.allowedLevel});
}

class SetInitialLevelFailure extends SetInitialLevelState {
  final String errorMessage;

  SetInitialLevelFailure(this.errorMessage);
}
