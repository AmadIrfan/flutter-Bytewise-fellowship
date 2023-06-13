import 'package:flutter/widgets.dart';
import 'package:flutter_instagram/model_view/model/auth_methods.dart';
import 'package:flutter_instagram/model_view/model/iuser.dart';

class UserProvider with ChangeNotifier {
  IUser? _user;
  final AuthMethods _authMethods = AuthMethods();
  IUser? get getUser => _user;
  Future<void> refreshUser() async {
    IUser user = await _authMethods.getUserData();

    _user = user;
    // print("${_user?.userId} ${_user?.userName}");
    notifyListeners();
  }
}
