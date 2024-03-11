part of 'habit_bloc.dart';

sealed class HabitEvent extends Equatable {
  const HabitEvent();

  @override
  List<Object> get props => [];
}

class OnAddHabitEvent extends HabitEvent {
  const OnAddHabitEvent(this.habit);

  final Habit habit;

  @override
  List<Object> get props => [habit];
}

class OnGetHabits extends HabitEvent {}

class OnCompleteHabitEvent extends HabitEvent {
  const OnCompleteHabitEvent(
      {required this.index, required this.completionDate});

  final int index;
  final DateTime completionDate; // For daily tracking

  @override
  List<Object> get props => [index];
}

class OnChangeDateEvent extends HabitEvent {
  const OnChangeDateEvent({required this.date});

  final DateTime date;

  @override
  List<Object> get props => [date];
}
