class LoginResponseModel {
  final String status;
  final String message;
  final String accessToken;

  LoginResponseModel({
    required this.status,
    required this.message,
    required this.accessToken,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      status: json['status'],
      message: json['message'],
      accessToken: json['accessToken'],
    );
  }
}
