import 'package:flutter/material.dart';
import 'global.dart';

class ChangeTheme with ChangeNotifier {
  String _theme = appSettings['theme']!;

  String get getTheme => _theme;

  void change() {
    _theme = appSettings['theme']!;
    notifyListeners();
  }
}

class ChangeProfile with ChangeNotifier {
  final bool _profile = true;

  bool get get => _profile;

  void change() {
    notifyListeners();
  }
}

class ChangeNavigation with ChangeNotifier {
  int _index = 0;
  bool _switch = false;

  bool get getSwitch => _switch;

  int get getIndex {
    _switch = false;
    return _index;
  }

  void change(int index) {
    _index = index;
    _switch = true;
    notifyListeners();
  }
}