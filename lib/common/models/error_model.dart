class ErrorModel {
  int? statusCode;
  String? statusMessage;
  bool? success;

  ErrorModel({this.statusCode, this.statusMessage, this.success});

  ErrorModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    statusMessage = json['status_message'];
    success = json['success'];
  }
}
