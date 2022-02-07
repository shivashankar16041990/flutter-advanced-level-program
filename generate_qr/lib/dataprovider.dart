import 'package:flutter/material.dart';

class TextValue with ChangeNotifier{
  TextValue({required this.text});
  String text;
  void updateText({required String updatedText}){
    text=updatedText;
    notifyListeners();
  }
}