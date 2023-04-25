import 'dart:convert';

import 'package:podify/constants/error_handling.dart';
import 'package:podify/constants/global_var.dart';
import 'package:podify/constants/utils.dart';
import 'package:podify/models/users.dart';
import 'package:podify/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:podify/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  void getUserData(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token;
      if (prefs.getString("x-auth-token") != null) {
        token = prefs.getString("x-auth-token")!;
      } else {
        prefs.setString("x-auth-token", '');
      }
      var tokenRes = await http
          .post(Uri.http(uri, "/tokenisvalid"), headers: <String, String>{
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*',
        'x-auth-token': token!
      });
      var response = jsonDecode(tokenRes.body);
      if (response == true) {
        http.Response userRes =
            await http.get(Uri.http(uri, "/"), headers: <String, String>{
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'x-auth-token': token
        });
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(Uri.http(uri, "/api/signin"),
          body: jsonEncode({"email": email, "password": password}),
          headers: <String, String>{
            "Access-Control-Allow-Origin": "*",
            'Content-Type': 'application/json',
            'Accept': '*/*'
          });
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: (() async {
            SharedPreferences pref = await SharedPreferences.getInstance();
            // ignore: use_build_context_synchronously
            Provider.of<UserProvider>(context, listen: false).setUser(res.body);
            await pref.setString("x-auth-token", jsonDecode(res.body)['token']);
            // ignore: use_build_context_synchronously
            Navigator.pushNamedAndRemoveUntil(
                context, HomeScreen.routeName, (route) => false);
          }));
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void signUpUser(
      {required BuildContext context,
      required String email,
      required String password,
      required String name}) async {
    try {
      User user = User(
          id: '',
          name: name,
          email: email,
          password: password,
          type: '',
          token: '',
          library: []);
      http.Response res = await http.post(Uri.http(uri, "/api/signup"),
          body: user.toJson(),
          headers: <String, String>{
            "Access-Control-Allow-Origin": "*",
            'Content-Type': 'application/json',
            'Accept': '*/*'
          });
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: (() async {
            SharedPreferences pref = await SharedPreferences.getInstance();
            Provider.of<UserProvider>(context, listen: false).setUser(res.body);
            await pref.setString("x-auth-token", jsonDecode(res.body)['token']);
            showSnackBar(context, "Sign up done");
            Navigator.pushNamedAndRemoveUntil(
                context, HomeScreen.routeName, (route) => false);
          }));
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
