class RegisterRequestBody {
  final int organizationCode;
  final String email;
  final String password;

  RegisterRequestBody({
    required this.organizationCode,
    required this.email,
    required this.password,
  });

  factory RegisterRequestBody.fromJson(Map<String, dynamic> json) {
    return RegisterRequestBody(
      organizationCode: json["organizationCode"],
      email: json["email"],
      password: json["password"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "organizationCode": organizationCode,
      "email": email,
      "password": password,
    };
  }
}
