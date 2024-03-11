part of 'habit_bloc.dart';

class HabitState extends Equatable {
  const HabitState(
      {this.habits = const <Habit>[],
      required this.currentDate,
      this.errorMessage});

  final List<Habit> habits;
  final DateTime currentDate;
  final String? errorMessage;

  HabitState copyWith({
    List<Habit>? habits,
    DateTime? currentDate,
    String? errorMessage,
  }) {
    return HabitState(
      habits: habits ?? this.habits,
      currentDate: currentDate ?? this.currentDate,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [habits, currentDate, errorMessage];
}
