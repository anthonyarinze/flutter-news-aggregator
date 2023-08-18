class ErrorModel {
  final int code;
  final String status;
  final String message;
  ErrorModel({required this.code, required this.status, required this.message});

  ErrorModel.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        status = json['status'],
        message = json['message'];
}
