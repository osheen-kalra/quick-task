// models/task.dart
class Task {
  final String title;
  final DateTime dueDate;
  late final bool isCompleted;

  Task({required this.title, required this.dueDate, required this.isCompleted});
}
