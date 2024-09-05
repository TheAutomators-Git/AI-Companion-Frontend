import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import '../providers/category_selection_provider.dart'; // Import the provider

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final List<String> categories = [
    'Lifestyle', 'Career/School', 'Sports', 'Hobbies', 'Music', 'Movies',
    'TV', 'Art', 'Books', 'Theatre', 'Travel',
    'Fashion', 'Nature', 'Food', 'Cars', 'Technology',
    'Pets', 'Fitness/Wellness', 'Gaming'
  ];

  String warningMessage = '';

  @override
  Widget build(BuildContext context) {
    // Access the provider
    final categoryProvider = Provider.of<CategorySelectionProvider>(context);
    final selectedCategories = categoryProvider.selectedCategories;

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Categories'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = 600;
          double gridWidth = constraints.maxWidth < maxWidth
              ? constraints.maxWidth
              : maxWidth;

          return Container(
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: SizedBox(
                width: gridWidth,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Please Select Some Categories to Continue from below",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    if (warningMessage.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            warningMessage,
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          ),
                        ),
                      ),
                    Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.all(10.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (selectedCategories.contains(index)) {
                                  categoryProvider.toggleCategory(index);
                                  warningMessage = '';
                                } else {
                                  if (selectedCategories.length < 5) {
                                    categoryProvider.toggleCategory(index);
                                    warningMessage = '';
                                  } else {
                                    warningMessage =
                                        'You can select max 5 categories.';
                                  }
                                }
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: selectedCategories.contains(index)
                                    ? Color(0xFFfc5656)
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
                      padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: selectedCategories.length >= 5
                              ? () {
                                  Navigator.pushNamed(context, '/home');
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: Text('Continue'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
