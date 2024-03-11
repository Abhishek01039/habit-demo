import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:streak_goal/feature/habit/data/repository/habit_repo_impl.dart';
import 'package:streak_goal/feature/habit/domain/entities/habit.dart';
import 'package:streak_goal/feature/habit/presentation/bloc/habit_bloc.dart';
import 'package:streak_goal/utils/exception.dart';

// Mock FirebaseHabitRepository for testing
class MockFirebaseHabitRepository extends Mock
    implements FirebaseHabitRepository {}

class MockHabit extends Mock implements Habit {}

void main() {
  late HabitBloc habitBloc;
  late MockFirebaseHabitRepository mockRepository;
  final habit1 = Habit(
    id: '1',
    name: 'Exercise',
    type: HabitType.daily,
    frequency: 1,
    streak: 0,
    completed: false,
  );

  final habit2 = Habit(
    id: '2',
    name: 'Read',
    type: HabitType.daily,
    frequency: 1,
    streak: 0,
    completed: false,
  );

  final DateTime dateTime = DateTime.now();

  setUpAll(() {
    mockRepository = MockFirebaseHabitRepository();
    habitBloc = HabitBloc(mockRepository, currentDate: dateTime);
    registerFallbackValue(MockHabit());
  });

  tearDownAll(() {
    habitBloc.close();
  });

  group('HabitBloc', () {
    blocTest<HabitBloc, HabitState>(
      'emits [HabitState] when OnChangeDateEvent is added',
      build: () => HabitBloc(mockRepository, currentDate: dateTime),
      act: (bloc) => bloc.add(OnChangeDateEvent(date: dateTime)),
      expect: () => [HabitState(currentDate: dateTime)],
    );

    blocTest<HabitBloc, HabitState>(
      'emits [HabitState] when OnCompleteHabitEvent is added',
      build: () => HabitBloc(mockRepository, currentDate: dateTime),
      act: (bloc) async {
        when(() => mockRepository.getHabits()).thenAnswer(
          (_) async => right(
            [
              habit1.copyWith(completed: true, frequency: habit1.frequency + 1),
            ],
          ),
        );
        when(() => mockRepository.updateHabit(any()))
            .thenAnswer((_) async => right(true));
        bloc.add(OnCompleteHabitEvent(index: 0, completionDate: dateTime));
      },
      seed: () {
        return HabitState(currentDate: dateTime, habits: [habit1]);
      },
      expect: () => [
        HabitState(currentDate: dateTime, habits: [
          habit1.copyWith(completed: true, frequency: habit1.frequency + 1)
        ])
      ],
    );

    blocTest<HabitBloc, HabitState>(
      'emits [HabitState(errorMessage: "Error message")] when OnCompleteHabitEvent throws exception',
      build: () => HabitBloc(mockRepository, currentDate: dateTime),
      act: (bloc) async {
        when(() => mockRepository.getHabits()).thenAnswer(
          (_) async => right(
            [
              habit1.copyWith(completed: true, frequency: habit1.frequency + 1),
            ],
          ),
        );
        when(() => mockRepository.updateHabit(any())).thenAnswer(
            (_) async => left(CustomException(cause: 'Error message')));
        bloc.add(OnCompleteHabitEvent(index: 0, completionDate: dateTime));
      },
      seed: () {
        return HabitState(currentDate: dateTime, habits: [habit1]);
      },
      expect: () => [
        HabitState(
            currentDate: dateTime,
            habits: [habit1],
            errorMessage: 'Error message')
      ],
    );

    blocTest<HabitBloc, HabitState>(
      'emits [HabitState] when OnGetHabits is added',
      build: () => HabitBloc(mockRepository, currentDate: dateTime),
      act: (bloc) async {
        when(() => mockRepository.getHabits())
            .thenAnswer((_) async => right([habit1, habit2]));
        bloc.add(OnGetHabits());
        await untilCalled(() => mockRepository.getHabits());
      },
      expect: () => [
        HabitState(currentDate: dateTime, habits: [habit1, habit2])
      ],
    );

    blocTest<HabitBloc, HabitState>(
      'emits [HabitState(errorMessage: "Error message")] when getHabits throws exception',
      build: () => HabitBloc(mockRepository, currentDate: dateTime),
      act: (bloc) async {
        when(() => mockRepository.getHabits()).thenAnswer(
            (_) async => left(CustomException(cause: "Error message")));
        bloc.add(OnGetHabits());
        await untilCalled(() => mockRepository.getHabits());
      },
      expect: () =>
          [HabitState(currentDate: dateTime, errorMessage: "Error message")],
    );

    blocTest<HabitBloc, HabitState>(
      'emits [HabitState] when OnAddHabitEvent is added',
      build: () => HabitBloc(mockRepository, currentDate: dateTime),
      act: (bloc) async {
        when(() => mockRepository.addHabit(any()))
            .thenAnswer((_) async => right(true));
        when(() => mockRepository.getHabits())
            .thenAnswer((_) async => right([habit2]));
        bloc.add(OnAddHabitEvent(habit2));
        await untilCalled(() => mockRepository.addHabit(any()));
      },
      expect: () => [
        HabitState(currentDate: dateTime, habits: [habit2])
      ],
    );

    blocTest<HabitBloc, HabitState>(
      'emits [HabitState(errorMessage: "Error message")] when addHabit throws exception',
      build: () => HabitBloc(mockRepository, currentDate: dateTime),
      act: (bloc) async {
        when(() => mockRepository.addHabit(any())).thenAnswer(
            (_) async => left(CustomException(cause: 'Error message')));
        when(() => mockRepository.getHabits())
            .thenAnswer((_) async => right([habit2]));
        bloc.add(OnAddHabitEvent(habit2));
        await untilCalled(() => mockRepository.addHabit(any()));
      },
      expect: () =>
          [HabitState(currentDate: dateTime, errorMessage: 'Error message')],
    );
  });
}
