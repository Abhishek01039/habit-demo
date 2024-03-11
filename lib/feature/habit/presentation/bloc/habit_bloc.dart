import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:streak_goal/feature/habit/data/repository/habit_repo_impl.dart';
import 'package:streak_goal/feature/habit/domain/entities/habit.dart';

part 'habit_event.dart';
part 'habit_state.dart';

class HabitBloc extends Bloc<HabitEvent, HabitState> {
  HabitBloc(this.firebaseHabitRepository, {DateTime? currentDate})
      : super(HabitState(currentDate: currentDate ?? DateTime.now())) {
    on<OnAddHabitEvent>(_onAddHabitEvent);
    on<OnGetHabits>(_onGetHabits);
    on<OnChangeDateEvent>(_onChangeDateEvent);
    on<OnCompleteHabitEvent>(_onCompleteHabitEvent);
  }

  FutureOr<void> _onChangeDateEvent(
      OnChangeDateEvent event, Emitter<HabitState> emit) {
    emit(state.copyWith(
      currentDate: event.date,
    ));
  }

  FutureOr<void> _onCompleteHabitEvent(
      OnCompleteHabitEvent event, Emitter<HabitState> emit) async {
    final habit = state.habits[event.index];
    if (habit.type == HabitType.daily) {
      _updateDailyStreak(habit);
    } else {
      _updateWeeklyStreak(habit);
    }
    habit.completed = !habit.completed;
    habit.lastCompleted = state.currentDate;
    final result = await firebaseHabitRepository.updateHabit(habit);
    result.fold((l) => emit(state.copyWith(errorMessage: l.cause)),
        (r) => add(OnGetHabits()));
  }

  FutureOr<void> _onGetHabits(
      OnGetHabits event, Emitter<HabitState> emit) async {
    final result = await firebaseHabitRepository.getHabits();
    result.fold((l) => emit(state.copyWith(errorMessage: l.cause)),
        (r) => emit(state.copyWith(habits: r)));
  }

  FutureOr<void> _onAddHabitEvent(
      OnAddHabitEvent event, Emitter<HabitState> emit) async {
    final result = await firebaseHabitRepository.addHabit(event.habit);
    result.fold((l) => emit(state.copyWith(errorMessage: l.cause)),
        (r) => add(OnGetHabits()));
  }

  void _updateDailyStreak(Habit habit) {
    if (habit.lastCompleted != null &&
        (habit.lastCompleted!.difference(state.currentDate).inDays.abs() > 1 ||
            state.currentDate.day == 1)) {
      habit.streak++;
    } else {
      habit.streak = 1;
    }
  }

  void _updateWeeklyStreak(Habit habit) {
    // Assuming goal is to complete habit `frequency` times per week
    final startOfWeek = state.currentDate
        .subtract(Duration(days: state.currentDate.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    final completionsThisWeek = state.habits
        .where((h) =>
            h.type == HabitType.weekly &&
            h.lastCompleted != null &&
            h.lastCompleted!
                .isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
            h.lastCompleted!.isBefore(endOfWeek.add(const Duration(days: 1))))
        .length;

    if (completionsThisWeek >= habit.frequency) {
      habit.streak++;
    } else {
      habit.streak = 0;
    }
  }

  final FirebaseHabitRepository firebaseHabitRepository;
}
