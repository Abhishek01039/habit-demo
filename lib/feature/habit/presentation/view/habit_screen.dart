import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:streak_goal/feature/habit/presentation/bloc/habit_bloc.dart';
import 'package:streak_goal/feature/habit/presentation/widgets/add_habit_dialog.dart';
import 'package:streak_goal/feature/habit/presentation/widgets/date_picker.dart';
import 'package:streak_goal/utils/error_dialogs.dart';

class HabitScreen extends StatelessWidget {
  const HabitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Habit Tracker')),
      body: BlocListener<HabitBloc, HabitState>(
        listener: (context, state) async {
          if (state.errorMessage != null) {
            await showErrorDialog(context, state.errorMessage ?? '');
          }
        },
        child: BlocConsumer<HabitBloc, HabitState>(
          listenWhen: (previous, current) =>
              previous.currentDate != current.currentDate,
          listener: (context, state) {
            for (int i = 0; i < state.habits.length; i++) {
              context.read<HabitBloc>().add(OnCompleteHabitEvent(
                  index: i, completionDate: DateTime.now()));
            }
          },
          builder: (context, state) {
            if (state.habits.isEmpty) {
              return const Center(
                child: Text('No Habits Found. Please create just now'),
              );
            } else {
              return Column(
                children: [
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        DateFormat('EEEE, MMMM d, yyyy')
                            .format(state.currentDate),
                        style: const TextStyle(fontSize: 20),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          await habitDatePicker(context);
                        },
                        child: const Text('Change Date'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.habits.length,
                      itemBuilder: (context, index) {
                        final habit = state.habits[index];
                        return ListTile(
                          isThreeLine: true,
                          title: Text(habit.name),
                          subtitle: Text('Streak: ${habit.streak}'),
                          trailing: ElevatedButton(
                            onPressed: () {
                              context.read<HabitBloc>().add(
                                  OnCompleteHabitEvent(
                                      index: index,
                                      completionDate: DateTime.now()));
                            },
                            child: const Text('Done'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showAddHabitDialog(context, context.read<HabitBloc>());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
