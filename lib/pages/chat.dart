import 'dart:io';

import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();
  bool _isWriting = false;
  List<ChatMessage> _messages = [
    /*
    ChatMessage(text: 'Hola mundo', uid: '123', animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 2000)),),
    ChatMessage(text: 'Hola mundo', uid: '123',),
    ChatMessage(text: 'Hola mundo', uid: '2',),
    ChatMessage(text: 'Hola mundo', uid: '2',),
    ChatMessage(text: 'Hola mundo', uid: '123',),

     */
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              //user.name.substring(0, 2)
              child: Text(
                'JO',
                style: TextStyle(color: Colors.blue[400]),
              ),
              backgroundColor: Colors.blue[100],
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              'Johan',
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
    if(text.length==0){
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
    setState(() {
      _isWriting = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    for(var message in _messages){
      message.animationController.dispose();
    }
    super.dispose();
  }
}
