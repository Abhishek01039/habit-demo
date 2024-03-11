// Repository
import 'package:dartz/dartz.dart';
import 'package:streak_goal/feature/habit/domain/entities/habit.dart';
import 'package:streak_goal/utils/exception.dart';

abstract class HabitRepository {
  Future<Either<CustomException, bool>> addHabit(Habit habit);

  Future<Either<CustomException, bool>> updateHabit(Habit habit);

  Future<Either<CustomException, List<Habit>>> getHabits();
}
