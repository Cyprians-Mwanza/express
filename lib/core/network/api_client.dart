import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../data/models/auth_response_model.dart';
import '../../data/models/sign_in_model.dart';
import '../../data/models/sign_up_model.dart';
import '../../data/models/user_model.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: "https://api.kuzadev.online")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @POST("/auth/sign-up")
  Future<AuthResponseModel> signUp(@Body() SignUpModel body);

  @POST("/auth/sign-in")
  Future<AuthResponseModel> signIn(@Body() SignInModel body);

  @GET("/users")
  Future<List<UserModel>> getUsers(@Header("Authorization") String token);
}
