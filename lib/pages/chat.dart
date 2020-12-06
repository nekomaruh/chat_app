import 'dart:io';

import 'package:chat_app/models/messages_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();
  bool _isWriting = false;
  ChatService chatService;
  SocketService socketService;
  AuthService authService;
  List<ChatMessage> _messages = [];

  @override
  void initState() {
    // TODO: implement initState
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);

    this.socketService.socket.on('personal-message', _listenMessage);
    _loadMessages(this.chatService.userTo.uid);

    super.initState();
  }

  Future<void> _loadMessages(String uid) async {
    List<Mensaje> chat = await this.chatService.getChat(uid);
    final history = chat.map((e) => ChatMessage(
        text: e.msg,
        uid: e.uid,
        animationController: new AnimationController(
            vsync: this, duration: Duration(milliseconds: 0))));
    setState(() => _messages.insertAll(0, history));
  }

  void _listenMessage(dynamic payload) {
    ChatMessage message = ChatMessage(
        text: payload['msg'],
        uid: payload['uid'],
        animationController: new AnimationController(
            vsync: this, duration: Duration(milliseconds: 300)));
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    //final chatService = Provider.of<ChatService>(context);
    final userTo = this.chatService.userTo;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              //user.name.substring(0, 2)
              child: Text(
                userTo.name.substring(0, 2),
                style: TextStyle(color: Colors.blue[400]),
              ),
              backgroundColor: Colors.blue[100],
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              userTo.name,
              style: TextStyle(color: Colors.black54),
            )
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                reverse: true,
                padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
                itemCount: _messages.length,
                itemBuilder: (_, i) {
                  return _messages[i];
                },
              ),
            ),
            Divider(
              height: 1,
            ),
            Container(
              //height: 50,
              color: Colors.white,
              child: _chatInput(),
            )
          ],
        ),
      ),
    );
  }

  _chatInput() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (String text) {
                  setState(() {
                    if (text.trim().length > 0) {
                      _isWriting = true;
                    } else {
                      _isWriting = false;
                    }
                  });
                },
                decoration: InputDecoration.collapsed(hintText: 'Send message'),
                focusNode: _focusNode,
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 0),
                child: Platform.isAndroid
                    ? IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: Icon(Icons.send),
                        onPressed: _isWriting
                            ? () => _handleSubmit(_textController.text.trim())
                            : null,
                      )
                    : CupertinoButton(
                        child: Text(
                          'SEND',
                          style: TextStyle().copyWith(fontSize: 15),
                        ),
                        onPressed: _isWriting
                            ? () => _handleSubmit(_textController.text.trim())
                            : null,
                      ))
          ],
        ),
      ),
    );
  }

  _handleSubmit(String text) {
    print(text);
    if (text.length == 0) {
      return;
    }
    _textController.clear();
    _focusNode.requestFocus();
    final message = new ChatMessage(
      text: text,
      uid: '123',
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 200)),
    );
    _messages.insert(0, message);
    message.animationController.forward();
    setState(() => _isWriting = false);
    this.socketService.emit('personal-message', {
      'from': this.authService.user.uid,
      'to': this.chatService.userTo.uid,
      'msg': text
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    for (var message in _messages) {
      message.animationController.dispose();
    }
    this.socketService.socket.off('personal-message');
    super.dispose();
  }
}
