import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_goal/feature/habit/presentation/bloc/habit_bloc.dart';

Future<void> habitDatePicker(BuildContext context) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );

  if (pickedDate != null) {
    if (context.mounted) {
      context.read<HabitBloc>().add(OnChangeDateEvent(date: pickedDate));
    }
  }
}
