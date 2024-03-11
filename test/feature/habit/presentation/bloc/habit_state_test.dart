import 'package:flutter_test/flutter_test.dart';
import 'package:streak_goal/feature/habit/domain/entities/habit.dart';
import 'package:streak_goal/feature/habit/presentation/bloc/habit_bloc.dart';

void main() {
  group('HabitState', () {
    final Habit habit = Habit(
      id: '1',
      name: 'Exercise',
      type: HabitType.daily,
      frequency: 1,
      streak: 0,
      completed: false,
    );

    test('copyWith should create a new instance with updated values', () {
      final currentDate = DateTime.now();
      final state = HabitState(
        habits: [habit],
        currentDate: currentDate,
        errorMessage: 'Error Message',
      );
      final newHabit = habit.copyWith(name: 'Updated Habit');

      final newState = state.copyWith(
        habits: [newHabit],
        currentDate: DateTime(2024, 3, 10),
        errorMessage: 'New Error Message',
      );

      expect(newState.habits, [newHabit]);
      expect(newState.currentDate, DateTime(2024, 3, 10));
      expect(newState.errorMessage, 'New Error Message');
    });

    test('props should return correct list of properties', () {
      final currentDate = DateTime.now();
      final state = HabitState(
        habits: [habit],
        currentDate: currentDate,
        errorMessage: 'Error Message',
      );

      expect(state.props, [
        [habit],
        currentDate,
        'Error Message',
      ]);
    });

    test('copyWith should return the same instance if no values are provided',
        () {
      final currentDate = DateTime.now();
      final state = HabitState(
        habits: [habit],
        currentDate: currentDate,
        errorMessage: 'Error Message',
      );

      final newState = state.copyWith();

      expect(newState, state);
    });
  });
}
