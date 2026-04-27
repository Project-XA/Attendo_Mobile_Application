class LoginStudentRequestBody {
  final String email;
  final String password;
  final String organizationCode;

  LoginStudentRequestBody({
    required this.email,
    required this.password,
    required this.organizationCode,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "organizationCode": organizationCode,
    };
  }

  factory LoginStudentRequestBody.fromJson(Map<String, dynamic> json) {
    return LoginStudentRequestBody(
      email: json['email'] as String,
      password: json['password'] as String,
      organizationCode: json['organizationCode'] as String,
    );
  }
}
