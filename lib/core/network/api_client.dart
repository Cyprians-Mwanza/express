import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../data/models/auth_response_model.dart';
import '../../data/models/user_model.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: "https://api.kuzadev.online")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @POST("/auth/sign-up")
  Future<AuthResponseModel> signUp(@Body() Map<String, dynamic> body);

  @POST("/auth/sign-in")
  Future<AuthResponseModel> signIn(@Body() Map<String, dynamic> body);

  @GET("/users")
  Future<List<UserModel>> getUsers(
      @Header("Authorization") String token,
      );
}
