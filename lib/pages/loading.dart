import 'package:chat_app/pages/login.dart';
import 'package:chat_app/pages/users.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Color(0xffF2F2F2),
        body: SafeArea(
      child: FutureBuilder(
        future: _checkLoginState(context),
        builder: (context, snapshot) {
          return Center(
            child: CircularProgressIndicator.adaptive(),
          );
        },
      ),
    ));
  }

  Future _checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context);
    final authenticated = await authService.isLoggedIn();
    if (authenticated) {
      // TODO: conectar al socket server
      socketService.connect();
      Navigator.pushReplacement(
          context, PageRouteBuilder(pageBuilder: (_, __, ___) => UsersPage()));
    } else {
      Navigator.pushReplacement(
          context, PageRouteBuilder(pageBuilder: (_, __, ___) => LoginPage()));
    }
  }
}
