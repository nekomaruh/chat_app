import 'package:chat_app/globals/environments.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting
}


class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;

  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;

  Future<void> connect() async {

    final authToken = await AuthService.getToken();

    // Dart client
    this._socket = IO.io(Environment.SOCKET_URL, {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders' : {
        'x-token' : authToken
      }
    });

    this._socket.on('connect', (_) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.on('disconnect', (_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

  }

  void disconnect() {
    this._socket.disconnect();
  }

}