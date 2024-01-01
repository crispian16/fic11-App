import 'package:dartz/dartz.dart';
import 'package:fic11_starter_pos/core/constants/variables.dart';
import 'package:fic11_starter_pos/data/datasources/auth_local_datasource.dart';
import 'package:fic11_starter_pos/data/model/response/auth_response_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteDatasource {
  Future<Either<String, AuthResponseModel>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('${Variables.baseUrl}/api/login'),
      body: {
        'email': username,
        'password': password,
      },
    );
    if (response.statusCode == 200) {
      return right(AuthResponseModel.fromJson(response.body));
    } else {
      return left(response.body);
    }
  }

  Future<Either<String, String>> logout() async {
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.post(
      Uri.parse('${Variables.baseUrl}/api/logout'),
      headers: {
        'Authorization': 'Bearer ${authData!.token}',
      },
    );
    if (response.statusCode == 200) {
      return Right(response.body);
    } else {
      return Left(response.body);
    }
  }
}
