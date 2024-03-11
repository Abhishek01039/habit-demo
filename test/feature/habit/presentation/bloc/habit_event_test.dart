import 'package:flutter_test/flutter_test.dart';
import 'package:streak_goal/feature/habit/domain/entities/habit.dart';
import 'package:streak_goal/feature/habit/presentation/bloc/habit_bloc.dart';

void main() {
  group('HabitEvent', () {
    test('OnAddHabitEvent should have correct props', () {
      final Habit habit = Habit(
        id: '1',
        name: 'Exercise',
        type: HabitType.daily,
        frequency: 1,
        streak: 0,
        completed: false,
      );

      final habitEvent1 = OnAddHabitEvent(habit);
      final habitEvent2 = OnAddHabitEvent(habit);

      expect(habitEvent1, habitEvent2);
      expect(habitEvent1.props, habitEvent2.props);
    });

    test('OnCompleteHabitEvent should have correct props', () {
      final date = DateTime.now();
      final completeEvent1 =
          OnCompleteHabitEvent(index: 1, completionDate: date);
      final completeEvent2 =
          OnCompleteHabitEvent(index: 1, completionDate: date);

      expect(completeEvent1, completeEvent2);
      expect(completeEvent1.props, completeEvent2.props);
    });

    test('OnChangeDateEvent should have correct props', () {
      final date1 = DateTime(2024, 3, 10);
      final date2 = DateTime(2024, 3, 10);
      final changeDateEvent1 = OnChangeDateEvent(date: date1);
      final changeDateEvent2 = OnChangeDateEvent(date: date2);

      expect(changeDateEvent1, changeDateEvent2);
      expect(changeDateEvent1.props, changeDateEvent2.props);
    });
  });
}
