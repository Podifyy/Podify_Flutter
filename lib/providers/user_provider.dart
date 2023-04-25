import 'package:podify/models/users.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: '',
    name: '',
    email: '',
    password: '',
    type: '',
    token: '',
    library: [],
  );

  User get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  void removeUser() {
    var json =
        "{'id': '','name': '','email': '','password': '','type': '','token': ''}";
    _user = User.fromJson(json);
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }
}
