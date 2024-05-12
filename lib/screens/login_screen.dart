import 'package:flutter/material.dart';
import 'package:quicktask_app/screens/home_screen.dart';
import 'package:quicktask_app/screens/signup_screen.dart'; // Import the SignupPage widget
import 'package:parse_server_sdk/parse_server_sdk.dart';

class LoginScreen extends StatelessWidget {
  final String? successMessage;
  const LoginScreen({Key? key, this.successMessage});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    String _errorMessage = '';

    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Color.fromARGB(255, 16, 173, 221), // Salmon color
      ),
      backgroundColor: Color.fromARGB(255, 16, 173, 221), // Salmon color
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                successMessage ?? '',
                style: const TextStyle(color: Color.fromARGB(255, 247, 249, 249)),
              ),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  filled: true,
                  fillColor: Colors.white, // White background
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0), // Rounded corners
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0), // Adjust padding
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  fillColor: Colors.white, // White background
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0), // Rounded corners
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0), // Adjust padding
                ),
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () async {
                  final username = _usernameController.text;
                  final password = _passwordController.text;

                  // Create a query for the Users class
                  final queryBuilder = QueryBuilder<ParseObject>(ParseObject('Users'))
                    ..whereEqualTo('username', username);

                  try {
                    // Perform the query
                    final response = await queryBuilder.query();

                    if (response.success && response.results != null && response.results!.isNotEmpty) {
                      // Get the first result
                      final userObject = response.results!.first;

                      // Check if the password matches
                      if (userObject.get<String>('password') == password) {
                        // Login successful
                        print('Login successful: $username');

                        // Navigate to the tasks page and pass the username
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen(username: username)), // Pass the username
                        );
                      } else {
                        // Password incorrect
                        _errorMessage = 'Incorrect password';
                      }
                    } else {
                      // User not found
                      _errorMessage = 'User not found';
                    }

                    if (_errorMessage.isNotEmpty) {
                      // Display error message
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(_errorMessage),
                        backgroundColor: Colors.red,
                      ));
                    }
                  } catch (e) {
                    // Handle query error
                    print('Query error: $e');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // White background
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Color.fromARGB(255, 16, 122, 229), // Salmon color
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to the sign-up page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupPage()),
                  );
                },
                child: const Text(
                  'Don\'t have an account? Sign Up',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
