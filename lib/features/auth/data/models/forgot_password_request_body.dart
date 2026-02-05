class ForgotPasswordRequestBody {
  final String email;

  ForgotPasswordRequestBody({required this.email});

  Map<String, dynamic> toJson() {
    return {
      "email": email,
    };
  }
}

