# Habit Tracking App Documentation

This documentation provides an overview of the habit tracking app, including its features, implementation details, and the rationale behind using specific packages.

## Features

- **Daily and Weekly Tracking**: Users can track habits either daily or weekly.
- **Streak Calculation**: Streaks are calculated based on consecutive days of habit completion or meeting weekly goals.
- **Error Handling**: Users are alerted when they try to add a habit without entering a name.

## Implementation Details

### Streak Calculation

- **Daily Streak**: The streak is incremented if the habit was completed yesterday or if the completed dates list is empty. Otherwise, the streak is reset to 1.
- **Weekly Streak**: The completion count is incremented for the week. If the completion count matches the frequency goal, the streak is incremented. If the completion count exceeds the frequency goal, the streak is reset to 1.

### Reset Streak on Missed Day/Week

- If the habit was not completed yesterday (for daily habits) or the completion count does not match the frequency goal (for weekly habits), the streak is reset to 0.

## Package Rationale

### bloc Package

The `bloc` package is used for state management in the app. It provides a way to manage the state of the app and separate the UI from the business logic.

### go_router Package

The `go_router` package is used for routing in the app. It provides a simple and flexible way to define and navigate between screens.

### equatable Package

The `equatable` package is used for value equality. It helps in comparing objects for equality based on their fields, which is useful for efficient state management in the `bloc` package.

### dartz Package

The `dartz` package is used for functional programming concepts in Dart. It provides tools for working with immutable data structures, handling errors, and performing asynchronous operations in a more functional style.

## File Structure

```
lib/
|-- core/
|   |-- entities/
|   |   |-- habit.dart
|   |-- repositories/
|   |   |-- habit_repository.dart
|-- features/
|   |-- habit/
|   |   |-- presentation/
|   |   |   |-- habit_screen.dart
|   |   |-- widgets/
|   |   |   |-- Widget related to habit feature
|   |   |-- domain/
|   |   |   |-- entities/
|   |   |   |   |-- habit.dart
|   |   |   |-- repositories/
|   |   |   |   |-- habit_repository.dart
|   |   |   |-- bloc/
|   |   |   |   |-- habit_bloc.dart
|   |   |   |   |-- habit_event.dart
|   |   |   |   |-- habit_state.dart
|-- main.dart
```

## Code Example

Here's an example of how streaks are updated in the `HabitBloc` class:

```dart
void _updateDailyStreak(Habit habit, DateTime completionDate) {
  final today = DateTime.now();
  final yesterday = today.subtract(Duration(days: 1));

  if (habit.completedDates.isEmpty || habit.completedDates.last != yesterday) {
    habit.streak = 1;
  } else {
    habit.streak++;
  }

  if (habit.streak > habit.longestStreak) {
    habit.longestStreak = habit.streak;
  }

  habit.completedDates.add(completionDate);
}

void _updateWeeklyStreak(Habit habit) {
  habit.completionCount++;

  if (habit.completionCount == habit.frequency) {
    habit.streak++;
  } else if (habit.completionCount > habit.frequency) {
    habit.streak = 1;
    habit.completionCount = 1;
  }

  if (habit.streak > habit.longestStreak) {
    habit.longestStreak = habit.streak;
  }
}
```

## Conclusion

The habit tracking app provides users with a simple and effective way to track their habits and maintain streaks. With features like daily and weekly tracking and streak calculation, users can easily stay motivated and achieve their goals.
