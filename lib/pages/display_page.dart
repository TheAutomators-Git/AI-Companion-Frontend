import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'categories_page.dart'; // Import the CategoriesPage class

class DisplayPage extends StatefulWidget {
  @override
  _DisplayPageState createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  int _currentIndex = 0;

  final List<String> _imageUrls = [
    'lib/assets/screen2.jpg',
    'lib/assets/screen3.jpg',
  ];

  final List<String> _titles = [
    'Upload and Save a Summary of Your Life',
    'Learn New Insights About Yourself',
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> _descriptions = [
      const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'My purpose is to help you upload and save a summary of the most important parts of your life. Every human has a special mix of likes and favorites - your personal interest graph is as unique as your fingerprint - your story deserves to be saved and shared! Uploading part of your mind will have a number of benefits.',
          style: TextStyle(fontSize: 18, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16.0),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'With my help, you will be able to learn new insights about yourself. I will be able to provide recommendations that are curated to your unique tastes. I will create beautiful graphics that describe your life and favorites. And I will be a permanent way to save and store what is important to you.',
                style: TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/categories');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFfc5656),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: const Text('Click Here'),
            ),
          ],
        ),
      ),
    ];

    return Scaffold(
      appBar: null,
      body: Container(
        padding: const EdgeInsets.all(32.0),
        color: Colors.transparent,
        child: Column(
          children: [
            Expanded(
              child: CarouselSlider.builder(
                itemCount: _imageUrls.length,
                itemBuilder: (context, index, realIndex) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          _titles[_currentIndex],
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        constraints: const BoxConstraints(
                          maxWidth: 350,
                        ),
                        child: Image.asset(
                          _imageUrls[index],
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: 300, // Set a specific height for the images
                        ),
                      ),
                      Center(child: _descriptions[_currentIndex]),
                    ],
                  );
                },
                options: CarouselOptions(
                  height: double.infinity, // Use the full height
                  viewportFraction: 1.0,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _imageUrls.map((url) {
                int index = _imageUrls.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index
                        ? const Color(0xFFfc5656)
                        : Colors.grey,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
