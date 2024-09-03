import 'package:flutter/material.dart';
import 'display_page.dart'; // Import the DisplayPage

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final List<String> categories = [
    'Music', 'Art', 'Travel', 'Technology', 'Sports', 'Cooking',
    'Fitness', 'Gaming', 'Reading', 'Movies', 'Photography',
    'Science', 'Writing', 'Fashion', 'History', 'Nature',
    'Dance', 'Languages', 'Entrepreneurship'
  ];

  Set<int> selectedCategories = Set<int>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = 600; // Set your desired maximum width here
          double gridWidth = constraints.maxWidth < maxWidth
              ? constraints.maxWidth
              : maxWidth;

          return Center(
            child: SizedBox(
              width: gridWidth,
              child: Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.all(10.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3 / 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedCategories.contains(index)) {
                                selectedCategories.remove(index);
                              } else {
                                selectedCategories.add(index);
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: selectedCategories.contains(index)
                                  ? Color(0xFFfc5656) // Updated color
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              categories[index],
                              style: TextStyle(
                                color: selectedCategories.contains(index)
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: selectedCategories.length >= 5
                          ? () {
                              // Navigate to DisplayPage
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DisplayPage(),
                                ),
                              );
                            }
                          : null,
                      child: Text('Next'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
