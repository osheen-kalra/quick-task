import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:quicktask_app/screens/login_screen.dart';

class SignupPage extends StatelessWidget {
  final String? successMessage;

  const SignupPage({Key? key, this.successMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _confirmPasswordController = TextEditingController();

    String _errorMessage = '';

    return Scaffold(
      key: key,
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Color.fromARGB(255, 16, 173, 221), // Salmon color
      ),
      backgroundColor:Color.fromARGB(255, 16, 173, 221), // Salmon color
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
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
              const SizedBox(height: 16.0),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
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
                  final confirmPassword = _confirmPasswordController.text;

                  if (password != confirmPassword) {
                    _errorMessage = 'Passwords do not match';
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(_errorMessage),
                      backgroundColor: Colors.red,
                    ));
                    return;
                  }
                  ParseObject user = ParseObject('Users');
                  user.set('username', username);
                  user.set('password', password);
                  try {
                    final response = await user.save();
                    if (response.success) {
                      // User registration successful
                      print('User registration successful: $username');

                      // Redirect to login page with success message
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(successMessage: 'Sign up successful. Please log in.'),
                        ),
                      );
                    } else {
                      // User registration failed
                      _errorMessage = response.error!.message;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(_errorMessage),
                        backgroundColor: Colors.red,
                      ));
                    }
                  } catch (e) {
                    // Handle sign-up error
                    print('Sign-up error: $e');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // White background
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.blue, // Salmon color
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
