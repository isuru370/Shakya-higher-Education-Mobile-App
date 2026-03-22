class StudentsCustomIdRequestModel {
  final String token;
  final String? search;
  final String? month;

  StudentsCustomIdRequestModel({
    required this.token,
    this.search,
    this.month,
  });
}
