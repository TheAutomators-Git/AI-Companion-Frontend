import 'package:flutter/material.dart';

class IntroductionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/assets/logo.png',
                  height: 100,
                  width: 100,
                ),
                const SizedBox(height: 25),
                const Text(
                  'Welcome to AI Companion!',
                  style: TextStyle(fontSize: 26, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                const Text(
                  'An AI Based Companion App to generate pictures that stand out :)',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 240,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -70,
            left: -70,
            child: Image.asset(
              'lib/assets/favlist.png',
              height: 300,
              width: 300,
            ),
          ),
        ],
      ),
    );
  }
}
