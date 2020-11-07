import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final users = [
    User(uid: '1', name: 'Johan', email: 'johan@gmail.com', online: true),
    User(uid: '2', name: 'Kevin', email: 'kevin@gmail.com', online: true),
    User(uid: '3', name: 'Vianney', email: 'vianney@gmail.com', online: false),
    User(uid: '4', name: 'Ercia', email: 'ercia@gmail.com', online: false),
    User(uid: '5', name: 'Esteban', email: 'esteban@gmail.com', online: false),
    User(
        uid: '6', name: 'Cristina', email: 'cristina@gmail.com', online: false),
    User(uid: '7', name: 'Claudia', email: 'vianney@gmail.com', online: false),
    User(uid: '8', name: 'Cathy', email: 'vianney@gmail.com', online: false),
    User(uid: '9', name: 'Carola', email: 'vianney@gmail.com', online: false),
  ];

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          authService.user.name,
          style: TextStyle(color: Colors.black54),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.exit_to_app,
            color: Colors.black54,
          ),
          onPressed: () {
            AuthService.deleteToken();
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.check_circle,
              color: Colors.blue[400],
            ),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _loadUsers,
        /*
        header: WaterDropHeader(
          //complete: Icon(Icons.check, color: Colors.blue[300],),
          waterDropColor: Colors.blue[400],
        ),

         */
        child: _userListView(),
      )
    );
  }

  _userListView() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 10),
      itemBuilder: (_, i) => _userListTile(users[i]),
      separatorBuilder: (_, i) => Divider(),
      itemCount: users.length,
    );
  }

  _userListTile(User user) {
    return ListTile(
      title: Text(user.name),
      leading: CircleAvatar(
        child: Text(user.name.substring(0, 2)),
        backgroundColor: Colors.blue[100],
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: user.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
    );
  }

  _loadUsers() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }



}
