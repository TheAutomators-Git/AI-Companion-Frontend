import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'login_page.dart';
import 'categories_page.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  DateTime? _selectedDate;
  bool _isLoading = false;

  // Replace with your FastAPI backend URL
  final String _backendUrl = "http://127.0.0.1:8000/api/register";

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
                  'lib/assets/favlist.png', // Ensure the image is listed in pubspec.yaml
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
                          controller: _emailController,
                          labelText: 'Email',
                          keyboardType: TextInputType.emailAddress,
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
                        _isLoading
                            ? CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: _signUpUser,
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 18),
                                  minimumSize: const Size(double.infinity, 45),
                                ),
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(fontSize: 16),
                                ),
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
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: const Color.fromARGB(0, 255, 255, 255),
      ),
      validator: (value) {
        if (labelText == 'Email' && (value == null || !value.contains('@'))) {
          return 'Please enter a valid email address';
        }
        return null;
      },
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

  Future<void> _signUpUser() async {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _selectedDate == null ||
        _phoneController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _stateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Prepare the request payload
    Map<String, dynamic> requestData = {
      'id': _emailController.text,  // Assuming email is used as ID for now
      'email': _emailController.text,
      'password': _passwordController.text,
      'birthday': DateFormat('yyyy-MM-dd').format(_selectedDate!),
      'contact': _phoneController.text,
      'city': _cityController.text,
      'state': _stateController.text,
    };

    try {
      // Send the POST request to the backend
      final response = await http.post(
        Uri.parse(_backendUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        // Navigate to CategoriesPage on success
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoriesPage(),
          ),
        );
      } else {
        // Handle error response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign up failed: ${response.body}')),
        );
      }
    } catch (e) {
      // Handle network errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
