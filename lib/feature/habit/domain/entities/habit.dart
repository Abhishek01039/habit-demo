// Data models
// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Habit extends Equatable {
  Habit({
    this.id,
    required this.name,
    required this.type,
    this.days = const [],
    this.frequency = 0,
    this.completed = false,
    this.streak = 0,
    this.lastCompleted,
  });

  final String? id;
  final String name;
  final HabitType type;
  final List<int>
      days; // For daily habits, 0 = Sunday, 1 = Monday, ..., 6 = Saturday
  final int frequency; // For weekly habits, how many times per week
  bool completed;
  int streak;
  DateTime? lastCompleted;

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['docId'],
      name: json['name'],
      type: HabitType.values
          .firstWhere((element) => element.toString() == json['type']),
      days: json['days'] == null ? [] : List<int>.from(json['days']),
      frequency: json['frequency'] ?? 0,
      completed: json['completed'],
      streak: json['streak'],
      lastCompleted: (json['lastCompleted'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString(),
      'days': days,
      'frequency': frequency,
      'completed': completed,
      'streak': streak,
      'lastCompleted': lastCompleted,
    };
  }

  Habit copyWith({
    String? id,
    String? name,
    HabitType? type,
    List<int>? days,
    int? frequency,
    bool? completed,
    int? streak,
    DateTime? lastCompleted,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      days: days ?? this.days,
      frequency: frequency ?? this.frequency,
      completed: completed ?? this.completed,
      streak: streak ?? this.streak,
      lastCompleted: lastCompleted ?? this.lastCompleted,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        days,
        frequency,
        completed,
        streak,
        lastCompleted,
      ];
}

enum HabitType {
  daily,
  weekly,
}
