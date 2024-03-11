import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:streak_goal/feature/habit/domain/entities/habit.dart';
import 'package:streak_goal/feature/habit/presentation/bloc/habit_bloc.dart';

Future<void> showAddHabitDialog(
    BuildContext context, HabitBloc habitBloc) async {
  final TextEditingController controller = TextEditingController();
  HabitType selectedType = HabitType.daily;

  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Habit'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(hintText: 'Enter habit name'),
              ),
              ListTile(
                title: const Text('Daily'),
                leading: Radio<HabitType>(
                  value: HabitType.daily,
                  groupValue: selectedType,
                  onChanged: (value) {
                    setState(() {
                      selectedType = value ?? selectedType;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Weekly'),
                leading: Radio<HabitType>(
                  value: HabitType.weekly,
                  groupValue: selectedType,
                  onChanged: (value) {
                    setState(() {
                      selectedType = value ?? selectedType;
                    });
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String name = controller.text.trim();
                if (name.isNotEmpty) {
                  habitBloc.add(
                    OnAddHabitEvent(
                      Habit(
                        name: name,
                        type: selectedType,
                      ),
                    ),
                  );

                  context.pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      );
    },
  );
}
