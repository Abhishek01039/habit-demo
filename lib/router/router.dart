import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:streak_goal/feature/habit/data/repository/habit_repo_impl.dart';
import 'package:streak_goal/feature/habit/presentation/bloc/habit_bloc.dart';
import 'package:streak_goal/feature/habit/presentation/view/habit_screen.dart';

// GoRouter configuration
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => BlocProvider(
        create: (context) =>
            HabitBloc(FirebaseHabitRepository())..add(OnGetHabits()),
        child: const HabitScreen(),
      ),
    ),
  ],
);
