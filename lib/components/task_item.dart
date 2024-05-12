import 'package:flutter/material.dart';
import 'package:quicktask_app/models/task.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class TaskItem extends StatefulWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskItem({Key? key, required this.task, required this.onTap}) : super(key: key);

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.task.isCompleted;
  }

  Future<void> _updateTaskCompletion(bool newValue) async {
    setState(() {
      _isCompleted = newValue;
    });

    try {
      final queryBuilder = QueryBuilder<ParseObject>(ParseObject('Tasks'))
        ..whereEqualTo('task_name', widget.task.title);

      final response = await queryBuilder.query();

      if (response.success && response.results != null && response.results!.isNotEmpty) {
        final taskObject = response.results!.first;
        taskObject.set('is_task_completed', _isCompleted);
        final updatedTask = await taskObject.save();

        if (!updatedTask.success) {
          // Revert to the previous completion status if update fails
          setState(() {
            _isCompleted = !newValue;
          });
          widget.task.isCompleted = _isCompleted;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update task: ${updatedTask.error!.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task not found.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Handle any errors
      print('Error updating task: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.task.title),
      subtitle: Text('Due Date: ${widget.task.dueDate}'),
      trailing: Switch(
        value: _isCompleted,
        onChanged: (bool newValue) => _updateTaskCompletion(newValue),
        activeColor: Color.fromARGB(255, 220, 3, 236), // Customize the color when the task is completed
      ),
      onTap: widget.onTap,
    );
  }
}
