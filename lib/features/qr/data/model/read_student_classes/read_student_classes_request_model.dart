class ReadStudentClassesRequestModel {
  final String token;
  final String qrCode;

  ReadStudentClassesRequestModel({required this.token, required this.qrCode});

  Map<String, dynamic> toQuery() {
    return {'token': token, 'qr_code': qrCode};
  }
}
