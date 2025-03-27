import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:online_stores_app/injection_container.dart';
import 'package:online_stores_app/models/login_response_model.dart';
import 'package:online_stores_app/services/http_service.dart';
import 'package:online_stores_app/utils/constants.dart';

class AuthRepository {
  final HttpService httpService;

  AuthRepository({required this.httpService});

  Future<String> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await httpService.post(
      ApiRoutes.register,
      body: {'name': name, 'email': email, 'password': password},
    );

    if (response['status'] == 'success') {
      return response['message'];
    } else {
      throw Exception('Registration failed');
    }
  }

  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await httpService.post(
      ApiRoutes.login,
      body: {'email': email, 'password': password},
    );

    final result = LoginResponseModel.fromJson({
      "status": response['status'],
      "message": response['status'],
      "accessToken": response['data']['token'],
    });

    final storage = sl<FlutterSecureStorage>();
    await storage.write(key: 'accessToken', value: result.accessToken);

    return result;
  }

  Future<bool> authCheck() async {
    final response = await httpService.get(ApiRoutes.getUserProfile);

    return response['code'] != 401;
  }

  Future<String?> getToken() async {
    // get token from secure storage
    final storage = sl<FlutterSecureStorage>();
    final token = await storage.read(key: 'accessToken');

    return token;
  }

  void removeToken() {
    // remove token from secure storage
    final storage = sl<FlutterSecureStorage>();
    storage.delete(key: 'accessToken');
  }
}
