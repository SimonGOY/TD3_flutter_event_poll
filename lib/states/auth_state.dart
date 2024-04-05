import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:event_poll/configs.dart';
import 'package:event_poll/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthState extends ChangeNotifier {
  User? _currentUser;
  String? _token;

  User? get currentUser {
    return _currentUser;
  }

  String? get token {
    return _token;
  }

  bool get isLoggedIn {
    if (_currentUser != null && _token != null) {
      return true;
    }
    return false;
  }

  Future<User?> login(String username, String password) async {
    final loginResponse = await http.post(
      Uri.parse('${Configs.baseUrl}/auth/login'),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    if (loginResponse.statusCode == HttpStatus.ok) {
      _token = json.decode(loginResponse.body)['token'];

      final userResponse = await http.get(
        Uri.parse('${Configs.baseUrl}/users/me'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $_token',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );

      if (userResponse.statusCode == HttpStatus.ok) {
        _currentUser = User.fromJson(json.decode(userResponse.body));
        notifyListeners();
        return _currentUser;
      }
    }

    logout();
    return null;
  }

  void logout() {
    _token = null;
    _currentUser = null;
    notifyListeners();
  }
}
