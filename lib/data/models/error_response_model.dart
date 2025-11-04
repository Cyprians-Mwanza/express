import 'package:json_annotation/json_annotation.dart';
part 'error_response_model.g.dart';
@JsonSerializable()
class ErrorResponseModel{
  final String message;

  ErrorResponseModel({required this.message,});
  factory ErrorResponseModel.fromJson(Map<String, dynamic> json)=>
      _$ErrorResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorResponseModelToJson(this);
}