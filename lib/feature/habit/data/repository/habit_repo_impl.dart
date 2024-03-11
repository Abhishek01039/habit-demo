import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:streak_goal/feature/habit/domain/entities/habit.dart';
import 'package:streak_goal/feature/habit/domain/repository/habit_repo.dart';
import 'package:streak_goal/utils/exception.dart';

class FirebaseHabitRepository implements HabitRepository {
  FirebaseHabitRepository({CollectionReference? habitsCollection})
      : _habitsCollection =
            habitsCollection ?? FirebaseFirestore.instance.collection('habits');

  final CollectionReference _habitsCollection;

  @override
  Future<Either<CustomException, bool>> addHabit(Habit habit) async {
    try {
      final String docId = _habitsCollection.doc().id;
      await _habitsCollection.doc(docId).set({
        'name': habit.name,
        'type': habit.type.toString(),
        'frequency': habit.frequency,
        'days': habit.days,
        'completed': habit.completed,
        'streak': habit.streak,
        'lastCompleted': habit.lastCompleted,
        'docId': docId,
      });
      return right(true);
    } on FirebaseException catch (e) {
      return left(CustomException(cause: e.message));
    } catch (e) {
      return left(CustomException(cause: e.toString()));
    }
  }

  @override
  Future<Either<CustomException, List<Habit>>> getHabits() async {
    try {
      final querySnapshot = await _habitsCollection.get();
      return right(querySnapshot.docs
          .map((doc) => Habit.fromJson(doc.data() as Map<String, dynamic>))
          .toList());
    } on FirebaseException catch (e) {
      return left(CustomException(cause: e.message));
    } catch (e) {
      return left(CustomException(cause: e.toString()));
    }
  }

  @override
  Future<Either<CustomException, bool>> updateHabit(Habit habit) async {
    try {
      final doc = _habitsCollection.doc(habit.id);
      await doc.update({
        'name': habit.name,
        'type': habit.type.toString(),
        'frequency': habit.frequency,
        'days': habit.days,
        'completed': habit.completed,
        'streak': habit.streak,
        'lastCompleted': habit.lastCompleted,
      });
      return right(true);
    } on FirebaseException catch (e) {
      return left(CustomException(cause: e.message));
    } catch (e) {
      return left(CustomException(cause: e.toString()));
    }
  }
}
