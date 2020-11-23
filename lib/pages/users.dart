import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/services/users_service.dart';
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

  final usersService = UsersService();

  List<User> users = [];

  @override
  void initState() {
    // TODO: implement initState
    this._loadUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

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
              socketService.disconnect();
              AuthService.deleteToken();
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 10),
              child: Icon(
                socketService.serverStatus == ServerStatus.Online
                    ? Icons.check_circle
                    : Icons.cancel,
                color: socketService.serverStatus == ServerStatus.Online
                    ? Colors.blue[400]
                    : Colors.red,
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
          child: users == null ? Text('nada') : _userListView(),
        ));
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
      onTap: (){
        //print(user.name);
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.userTo = user;
        Navigator.pushNamed(context, 'chat');
      },
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
    this.users = await usersService.getUsers();
    setState(() {

    });
    //await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
