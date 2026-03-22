
import 'read_tute_model.dart';

class ReadTuteResponseModel {
  final String status;
  final int classTotal;
  final List<ReadTuteModel> data;

  ReadTuteResponseModel({
    required this.status,
    required this.classTotal,
    required this.data,
  });

  factory ReadTuteResponseModel.fromJson(Map<String, dynamic> json) {
    return ReadTuteResponseModel(
      status: json['status'],
      classTotal: json['total'] ?? 0,
      data: (json['data'] as List)
          .map((e) => ReadTuteModel.fromJson(e))
          .toList(),
    );
  }
}
