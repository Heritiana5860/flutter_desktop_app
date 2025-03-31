import 'package:flutter/material.dart';
import 'package:my_desktop_app/models/data_models.dart';

class MemberProvider with ChangeNotifier {
  DataModels? _selectedMember;

  DataModels? get selectedMember => _selectedMember;

  void selectMember(DataModels member) {
    _selectedMember = member;
    notifyListeners();
  }
}
