import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                labelText: 'Username',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color.fromARGB(0, 255, 255, 255),
              ),
            ),
            const SizedBox(
                height: 20), // Spacing between username and password fields
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
            const SizedBox(
                height: 10), // Spacing between password field and the button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () => {},
                    style: ButtonStyle(
                      // Optional: Change text color
                      overlayColor: MaterialStateProperty.all(
                          Colors.transparent), // No splash on press
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.zero),
                    ),
                    child: Text("Forgot Password?",
                        style: TextStyle(fontSize: 15)))
              ],
            ),
            const SizedBox(height: 40), // Spacing before the button
            Row(
              children: [
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical:
                              18), // Adjust the vertical padding to control the button's height
                      // Ensuring the button stretches
                      minimumSize: Size(double.infinity,
                          45), // Sets a minimum size for the button
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                          fontSize:
                              16), // Optional: Adjust text size if necessary
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
                height: 20), // Spacing between the button and the text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(width: 5),
                TextButton(
                    onPressed: () => {},
                    child: Text("Sign Up!", style: TextStyle(fontSize: 15)))
              ],
            )
          ],
        ),
      ),
    );
  }
}
