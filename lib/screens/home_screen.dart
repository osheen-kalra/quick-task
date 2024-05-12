import 'package:flutter/material.dart';
import 'package:quicktask_app/components/task_list.dart';
import 'package:quicktask_app/components/task_form.dart';

class HomeScreen extends StatelessWidget {
  final String username; // Add a field to receive the username

  const HomeScreen({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QuickTask'),
      ),
      body: Container(
        color: Color.fromARGB(255, 16, 173, 221), // Set background color to blue
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8.0),
              color: Colors.white, // Container background color
              child: Text(
                'Tasks',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: TaskList(username: username), // Pass the username to TaskList
            ),
            SizedBox(height: 16.0),
            Container(
              padding: EdgeInsets.all(8.0),
              color: Colors.white, // Container background color
              child: Text(
                'Add Task',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            TaskForm(username: username), // Pass the username to TaskForm
          ],
        ),
      ),
    );
  }
}
