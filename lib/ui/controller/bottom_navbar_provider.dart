import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class BottomNavBarProvider with ChangeNotifier {
  final RxInt _selectedIndex = 0.obs;

  int get selectedIndex => _selectedIndex.value;
  set selectedIndex(int index) {
    _selectedIndex.value = index;
    notifyListeners();

  }
}
