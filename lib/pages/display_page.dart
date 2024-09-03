import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DisplayPage extends StatefulWidget {
  @override
  _DisplayPageState createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  int _currentIndex = 0;

  final List<String> _imageUrls = [
    'https://via.placeholder.com/600x400.png?text=Image+1',
    'https://via.placeholder.com/600x400.png?text=Image+2',
    'https://via.placeholder.com/600x400.png?text=Image+3',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Display Page'),
      ),
      body: Container(
        color: Colors.white, // Ensure the background color is always white
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Heading
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Images',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            // Image Carousel
            Expanded(
              child: Stack(
                children: [
                  CarouselSlider.builder(
                    itemCount: _imageUrls.length,
                    itemBuilder: (context, index, realIndex) {
                      return Container(
                        constraints: BoxConstraints(
                          maxWidth: 350, // Set max width to 400px
                        ),
                        child: Image.network(
                          _imageUrls[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      );
                    },
                    options: CarouselOptions(
                      height: 400,
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
                  // Left arrow
                  Positioned(
                    left: 8,
                    top: 0,
                    bottom: 0,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.grey[700]),
                      onPressed: () {
                        setState(() {
                          _currentIndex = (_currentIndex - 1 + _imageUrls.length) % _imageUrls.length;
                        });
                      },
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 0,
                    bottom: 0,
                    child: IconButton(
                      icon: Icon(Icons.arrow_forward_ios, color: Colors.grey[700]),
                      onPressed: () {
                        setState(() {
                          _currentIndex = (_currentIndex + 1) % _imageUrls.length;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            // Dot indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _imageUrls.map((url) {
                int index = _imageUrls.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index
                        ? Color(0xFFfc5656) // Replace blue with #fc5656
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
