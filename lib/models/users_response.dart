// To parse this JSON data, do
//
//     final usersResponse = usersResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat_app/models/user.dart';

UsersResponse usersResponseFromJson(String str) => UsersResponse.fromJson(json.decode(str));

String usersResponseToJson(UsersResponse data) => json.encode(data.toJson());

class UsersResponse {
  UsersResponse({
    this.ok,
    this.usuarios,
  });

  bool ok;
  List<User> usuarios;

  factory UsersResponse.fromJson(Map<String, dynamic> json) => UsersResponse(
    ok: json["ok"],
    usuarios: List<User>.from(json["usuarios"].map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ok": ok,
    "usuarios": List<dynamic>.from(usuarios.map((x) => x.toJson())),
  };
}
