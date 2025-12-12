import 'package:mobile_app/feature/home/domain/entities/user_org.dart';

class User {
  final String nationalId;
  final String firstName;
  final String lastName;
  String get fullName => '$firstName $lastName';
  final String? birthDate;
  final String email;
  final List<UserOrg> organizations;

  User(
    this.firstName,
    this.lastName, {
    required this.nationalId,
    this.birthDate,
    required this.email,
    required this.organizations,
  });
}
