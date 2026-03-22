import 'system_user_model.dart';
import 'user_type_model.dart';

class UserModel {
  final int id;
  final String name;
  final String email;
  final UserTypeModel userType;
  final SystemUserModel systemUser;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
    required this.systemUser,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      userType: UserTypeModel.fromJson(json['user_type']),
      systemUser: SystemUserModel.fromJson(json['system_user']),
    );
  }
}
