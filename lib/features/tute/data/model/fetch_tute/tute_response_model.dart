import 'tute_model.dart';

class TuteResponseModel {
  final String status;
  final int total;
  final List<TuteModel> data;

  TuteResponseModel({
    required this.status,
    required this.total,
    required this.data,
  });

  factory TuteResponseModel.fromJson(Map<String, dynamic> json) {
    return TuteResponseModel(
      status: json['status'] ?? '',
      total: json['total'] ?? 0,
      data: json['data'] != null
          ? (json['data'] as List)
              .map((e) => TuteModel.fromJson(e))
              .toList()
          : [],
    );
  }
}