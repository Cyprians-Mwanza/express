import 'package:json_annotation/json_annotation.dart';
part 'sign_up_model.g.dart';

@JsonSerializable()
class SignUpModel {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  SignUpModel({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  factory SignUpModel.fromJson(Map<String, dynamic> json) =>
      _$SignUpModelFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpModelToJson(this);
}
