import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:quicktask_app/screens/home_screen.dart'; // Import Parse SDK

class TaskForm extends StatefulWidget {
  final String username; // Add username field

  const TaskForm({Key? key, required this.username}) : super(key: key);

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  late TextEditingController _titleController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _addTask() async {
    final title = _titleController.text;
    final dueDate = _selectedDate;
    final username = widget.username; // Get the username from the widget property

    // Create a new Parse object for the Task class
    final taskObject = ParseObject('Tasks')
      ..set('task_name', title)
      ..set('task_due_date', dueDate)
      ..set('username', username); // Set the username

    try {
      // Save the Parse object to the database
      final response = await taskObject.save();

      if (response.success) {
        // Task added successfully
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task added successfully.'),
            backgroundColor: Colors.green,
          ),
        );

        // Clear the text field after task is added
        _titleController.clear();
        // Navigate to the tasks page and pass the username
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(username: username)), // Pass the username
        );
      } else {
        // Task addition failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add task: ${response.error!.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Handle any errors
      print('Error adding task: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Task Title',
            ),
          ),
          const SizedBox(height: 10.0),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Due Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                ),
              ),
              TextButton(
                onPressed: () => _selectDate(context),
                child: const Text('Select Date'),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: _addTask, // Call _addTask function when button is pressed
            child: const Text('Add Task'),
          ),
        ],
      ),
    );
  }
}
