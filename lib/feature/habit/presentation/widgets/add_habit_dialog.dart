import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:streak_goal/feature/habit/domain/entities/habit.dart';
import 'package:streak_goal/feature/habit/presentation/bloc/habit_bloc.dart';

Future<void> showAddHabitDialog(
    BuildContext context, HabitBloc habitBloc) async {
  final TextEditingController controller = TextEditingController();
  final TextEditingController frequencyController = TextEditingController();
  HabitType selectedType = HabitType.daily;
  final formKey = GlobalKey<FormState>();

  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Habit'),
          content: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  decoration:
                      const InputDecoration(hintText: 'Enter habit name'),
                ),
                if (selectedType == HabitType.weekly)
                  TextFormField(
                    controller: frequencyController,
                    decoration: const InputDecoration(
                      hintText: 'Frequency in one week',
                      errorStyle: TextStyle(color: Colors.red),
                    ),
                    validator: (value) {
                      if (value?.isNotEmpty ?? false) {
                        if (int.parse(value ?? '0') <= 0 ||
                            int.parse(value ?? '0') >= 7) {
                          return 'Frequency must be between 0 and 7';
                        }
                      }
                      return null;
                    },
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: false),
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
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  final String name = controller.text.trim();
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
