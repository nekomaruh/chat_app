import 'dart:convert';
import 'dart:io';

import 'package:chat_app/globals/environments.dart';
import 'package:chat_app/models/login_response.dart';
import 'package:chat_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class AuthService with ChangeNotifier {

  // Create storage
  final _storage = new FlutterSecureStorage();

  User user;
  bool _authenticating = false;


  bool get authenticating => _authenticating;

  set authenticating(bool value) {
    _authenticating = value;
    notifyListeners();
  }

  // Getters del token de forma estática
  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    return await _storage.read(key: 'token');
  }

  // Borrar el token de forma estática
  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login({String email, String password}) async {
    this.authenticating = true;

    final data = {"email": email, "password": password};

    final res = await http.post('${Environment.API_URL}/login',
        body: json.encode(data), headers: {'Content-Type': 'application/json'});

    this.authenticating = false;

    if(res.statusCode==200){
      final loginRes = loginResponseFromJson(res.body);
      this.user = loginRes.usuario;
      this._saveToken(loginRes.token);
      print(res.body);
      return true;
    }else{
      return false;
    }

  }

  Future<bool> register({String email, String name, String password}) async {
    this.authenticating = true;

    final data = {"email": email, "password": password, "nombre" : name};

    print('${Environment.API_URL}/new');
    print(json.encode(data));

    final res = await http.post('${Environment.API_URL}/login/new',
        body: json.encode(data), headers: {'Content-Type': 'application/json'});

    this.authenticating = false;

    if(res.statusCode==200){
      final loginRes = loginResponseFromJson(res.body);
      this.user = loginRes.usuario;
      this._saveToken(loginRes.token);
      return true;
    }else{
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await this._storage.read(key: 'token');
    final res = await http.get('${Environment.API_URL}/login/renew',
        headers: {'Content-Type': 'application/json',
        'x-token' : token});
    if(res.statusCode==200){
      final loginRes = loginResponseFromJson(res.body);
      this.user = loginRes.usuario;
      this._saveToken(loginRes.token);
      print(token);
      return true;
    }else{
      this._logOut(token);
      return false;
    }
  }

  Future _saveToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future _logOut(String token) async {
    return await _storage.delete(key: 'token');
  }

}
