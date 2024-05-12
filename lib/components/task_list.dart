import 'package:flutter/material.dart';
import 'package:quicktask_app/components/task_item.dart';
import 'package:quicktask_app/models/task.dart';
import 'package:quicktask_app/screens/task_details.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class TaskList extends StatefulWidget {
  final String username; // Add this field to receive the username

  const TaskList({Key? key, required this.username}) : super(key: key);

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  late Future<List<Task>> _taskListFuture;

  @override
  void initState() {
    super.initState();
    _taskListFuture = fetchTasks();
  }

    Future<List<Task>> fetchTasks() async {
    try {
      final queryBuilder = QueryBuilder<ParseObject>(ParseObject('Tasks'));
      
      // Add a filter to only fetch tasks belonging to the current user
      queryBuilder.whereEqualTo('username', widget.username);
      
      final response = await queryBuilder.query();
      if (response.success && response.results != null) {
        final List<Task> tasks = response.results!
            .map((taskObject) => Task(
                  title: taskObject.get('task_name')!,
                  dueDate: taskObject.get<DateTime>('task_due_date')!,
                  isCompleted: taskObject.get('is_task_completed'),
                ))
            .toList();
        return tasks;
      } else {
        throw Exception('Failed to fetch tasks');
      }
    } catch (e) {
      throw Exception('Failed to fetch tasks: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<Task>>(
        future: _taskListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<Task> tasks = snapshot.data!;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (BuildContext context, int index) {
                return TaskItem(
                  task: tasks[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailPage(task: tasks[index]),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
