import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl/intl.dart';
import 'login_page.dart';
import 'categories_page.dart'; // Import the CategoriesPage

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = 400;
          double formWidth = constraints.maxWidth < maxWidth
              ? constraints.maxWidth
              : maxWidth;

          return Stack(
            children: [
              // Favorite list image at top left corner
              Positioned(
                top: -80,
                left: -60,
                child: Image.asset(
                  'lib/assets/favlist.png', // Make sure the image is listed in pubspec.yaml
                  width: 250,
                  height: 250,
                ),
              ),
              Center(
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
                          'Create an Account!',
                          style: TextStyle(fontSize: 26, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        _buildTextField(
                          controller: _usernameController,
                          labelText: 'Username',
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _passwordController,
                          labelText: 'Password',
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _cityController,
                                labelText: 'City',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildTextField(
                                controller: _stateController,
                                labelText: 'State',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildDatePicker(context),
                        const SizedBox(height: 20),
                        IntlPhoneField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Color.fromARGB(0, 255, 255, 255),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Row(
                          children: [
                            Flexible(
                              child: ElevatedButton(
                                onPressed: () {
                                  // Navigate to CategoriesPage when sign up is clicked
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CategoriesPage(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 18),
                                  minimumSize: const Size(double.infinity, 45),
                                ),
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account?",
                              style: TextStyle(fontSize: 15),
                            ),
                            const SizedBox(width: 5),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Login!",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText, 
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: const Color.fromARGB(0, 255, 255, 255),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return InkWell(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          setState(() {
            _selectedDate = pickedDate;
          });
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Birthday',
          border: OutlineInputBorder(),
          filled: true,
          fillColor: const Color.fromARGB(0, 255, 255, 255),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today),
            const SizedBox(width: 10),
            Text(
              _selectedDate != null
                  ? DateFormat('MM/dd/yyyy').format(_selectedDate!)
                  : 'Select your birthday',
            ),
          ],
        ),
      ),
    );
  }
}
