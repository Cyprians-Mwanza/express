import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';
@JsonSerializable()
class UserModel{
  final String id;
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String role;

  UserModel({
    required this.id,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.role,
});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson()=> _$UserModelToJson(this);
}