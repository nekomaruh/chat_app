import 'package:chat_app/globals/environments.dart';
import 'package:chat_app/models/messages_response.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier {
  User userTo;

  Future<List<Mensaje>> getChat(String userId) async {
    final res = await http.get('${Environment.API_URL}/mensajes/$userId',
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken()
        });
    final messagesResponse = messagesResponseFromJson(res.body);
    return messagesResponse.mensajes;
  }
}
