import 'package:chat_app/globals/environments.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/models/users_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:http/http.dart' as http;

class UsersService {
  Future<List<User>> getUsers() async {
    try {
      final res = await http.get('${Environment.API_URL}/usuarios', headers: {
        'Content-type': 'application/json',
        'x-token': await AuthService.getToken()
      });
      final usersRes = usersResponseFromJson(res.body);
      return usersRes.usuarios;
    } catch (e) {}
  }
}
