import 'package:flutter/material.dart';

class CategorySelectionProvider extends ChangeNotifier {
  Set<int> _selectedCategories = {};

  Set<int> get selectedCategories => _selectedCategories;

  void toggleCategory(int index) {
    if (_selectedCategories.contains(index)) {
      _selectedCategories.remove(index);
    } else {
      if (_selectedCategories.length < 5) {
        _selectedCategories.add(index);
      }
    }
    notifyListeners();
  }

  List<String> getSelectedCategoryNames(List<String> categories) {
    return _selectedCategories.map((index) => categories[index]).toList();
  }

  bool get canContinue => _selectedCategories.length >= 5;
}
