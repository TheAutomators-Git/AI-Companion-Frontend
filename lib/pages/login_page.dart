import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'display_page.dart'; // Import the DisplayPage
import 'sign_up.dart'; // Import the SignUpPage

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    final String email = _usernameController.text;
    final String password = _passwordController.text;

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/user/login'), // Updated URL for login
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, navigate to the display page
        final userData = jsonDecode(response.body);
        Navigator.pushNamed(context, '/display', arguments: userData);
      } else {
        // If the server does not return a 200 OK response, show an error message
        final errorData = jsonDecode(response.body);
        _showErrorDialog(context, errorData['detail']);
      }
    } catch (error) {
      _showErrorDialog(context, 'Something went wrong. Please try again.');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -30,
            left: -20,
            child: Image.asset(
              'lib/assets/favlist.png',
              height: 200, // Adjust the height as needed
              width: 200,  // Adjust the width as needed
              fit: BoxFit.cover,
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              double maxWidth = 400; // Set your desired maximum width here
              double formWidth = constraints.maxWidth < maxWidth
                  ? constraints.maxWidth
                  : maxWidth;

              return Center(
                child: SizedBox(
                  width: formWidth,
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Login Account!',
                          style: TextStyle(fontSize: 26, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Color.fromARGB(0, 255, 255, 255),
                          ),
                        ),
                        const SizedBox(height: 20), // Spacing between username and password fields
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true, // Use true to hide password
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Color.fromARGB(0, 255, 255, 255),
                          ),
                        ),
                        const SizedBox(height: 10), // Spacing between password field and the button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () => {}, // Add forgot password functionality here
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(Colors.transparent), // No splash on press
                                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                              ),
                              child: Text("Forgot Password?", style: TextStyle(fontSize: 15)),
                            )
                          ],
                        ),
                        const SizedBox(height: 40), // Spacing before the button
                        Row(
                          children: [
                            Flexible(
                              child: ElevatedButton(
                                onPressed: () => _login(context), // Call the login method
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 18),
                                  minimumSize: Size(double.infinity, 45),
                                ),
                                child: const Text(
                                  'Login',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20), // Spacing between the button and the text
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(width: 5),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUpPage(),
                                  ),
                                );
                              },
                              child: Text(
                                "Sign Up!",
                                style: TextStyle(fontSize: 15),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
