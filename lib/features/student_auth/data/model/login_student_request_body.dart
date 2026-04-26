class LoginStudentRequestBody {
  final String email;
  final String password;

  LoginStudentRequestBody({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {"email": email, "password": password};
  }

  factory LoginStudentRequestBody.fromJson(Map<String, dynamic> json) {
    return LoginStudentRequestBody(
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }
}
