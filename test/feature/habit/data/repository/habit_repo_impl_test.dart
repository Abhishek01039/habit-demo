// ignore_for_file: subtype_of_sealed_class

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:streak_goal/feature/habit/data/repository/habit_repo_impl.dart';
import 'package:streak_goal/feature/habit/domain/entities/habit.dart';
import 'package:streak_goal/utils/exception.dart';

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

void main() {
  late MockFirebaseFirestore mockFirebaseFirestore;
  late FirebaseHabitRepository firebaseHabitRepository;
  late MockCollectionReference mockCollectionReference;
  late MockDocumentReference mockDocumentReference;
  late MockQueryDocumentSnapshot mockQueryDocumentSnapshot;
  late MockQuerySnapshot mockQuerySnapshot;
  final habit = Habit(
    id: '1',
    name: 'Exercise',
    type: HabitType.daily,
    frequency: 1,
    days: const [1, 2, 3, 4, 5],
    completed: false,
    streak: 0,
    lastCompleted: null,
  );

  setUpAll(() {
    mockFirebaseFirestore = MockFirebaseFirestore();
    mockCollectionReference = MockCollectionReference();
    mockDocumentReference = MockDocumentReference();
    mockQuerySnapshot = MockQuerySnapshot();
    mockQueryDocumentSnapshot = MockQueryDocumentSnapshot();
    // Mock the behavior of collection() method to return the mockCollectionReference
    when(() => mockFirebaseFirestore.collection(any()))
        .thenReturn(mockCollectionReference);

    // Mock the behavior of doc() method to return the mockDocumentReference
    when(() => mockCollectionReference.doc(any()))
        .thenReturn(mockDocumentReference);

    firebaseHabitRepository =
        FirebaseHabitRepository(habitsCollection: mockCollectionReference);
  });

  group('FirebaseHabitRepository', () {
    test('addHabit - should add habit successfully', () async {
      when(() => mockDocumentReference.id).thenReturn('1');
      when(() => mockDocumentReference.set(any()))
          .thenAnswer((_) => Future.value());

      final result = await firebaseHabitRepository.addHabit(habit);

      expect(result, const Right(true));
    });

    test('addHabit - should return left CustomException on failure', () async {
      when(() => mockCollectionReference.doc(any()))
          .thenReturn(mockDocumentReference);
      when(() => mockDocumentReference.set(any())).thenThrow(Exception());

      final result = await firebaseHabitRepository.addHabit(habit);

      expect(result, isA<Left>());
    });
  });

  test('getHabits - should get habits successfully', () async {
    final habitsCollection = mockFirebaseFirestore.collection('habits');
    expect(habitsCollection, isA<MockCollectionReference>());

    // Simulate a query snapshot with one document
    when(() => mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
    when(() => mockQueryDocumentSnapshot.data()).thenReturn({
      'name': 'Exercise',
      'type': HabitType.daily.toString(),
      'frequency': 1,
      'days': [1, 2, 3, 4, 5],
      'completed': false,
      'streak': 0,
      'lastCompleted': null,
      'docId': '1',
    });
    when(() => mockCollectionReference.get())
        .thenAnswer((_) => Future.value(mockQuerySnapshot));

    final result = await firebaseHabitRepository.getHabits();

    expect(result, isA<Right>());
  });

  test('getHabits - should return left CustomException on getHabits failure',
      () async {
    final habitsCollection = mockFirebaseFirestore.collection('habits');
    expect(habitsCollection, isA<MockCollectionReference>());

    when(() => mockCollectionReference.get()).thenThrow(Exception());

    final result = await firebaseHabitRepository.getHabits();

    expect(result, isA<Left>());
    expect(result.swap().getOrElse(() => CustomException(cause: '')),
        isA<CustomException>());
  });

  test('updateHabit - should update habit successfully', () async {
    when(() => mockDocumentReference.update(any()))
        .thenAnswer((_) => Future.value());

    final result = await firebaseHabitRepository.updateHabit(habit);

    expect(result, isA<Right>());
  });

  test(
      'updateHabit - should return left CustomException on updateHabit failure',
      () async {
    when(() => mockDocumentReference.update(any())).thenThrow(Exception());

    final result = await firebaseHabitRepository.updateHabit(habit);

    expect(result, isA<Left>());
    expect(result.swap().getOrElse(() => CustomException(cause: '')),
        isA<CustomException>());
  });
}
