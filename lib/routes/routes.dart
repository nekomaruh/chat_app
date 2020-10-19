import 'package:chat_app/pages/chat.dart';
import 'package:chat_app/pages/loading.dart';
import 'package:chat_app/pages/login.dart';
import 'package:chat_app/pages/register.dart';
import 'package:chat_app/pages/users.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> appRoutes = {
  'users' : (_) => UsersPage(),
  'chat' : (_) => ChatPage(),
  'login' : (_) => LoginPage(),
  'register' : (_) => RegisterPage(),
  'loading' : (_) => LoadingPage(),
};