import 'class_room_item_model.dart';

class GetClassesByGradeResponseModel {
  final String status;
  final String gradeId;
  final Map<String, Map<String, List<ClassRoomItemModel>>> data;

  GetClassesByGradeResponseModel({
    required this.status,
    required this.gradeId,
    required this.data,
  });

  factory GetClassesByGradeResponseModel.fromJson(Map<String, dynamic> json) {
    final Map<String, Map<String, List<ClassRoomItemModel>>> parsedData = {};

    final rawData = json['data'] as Map<String, dynamic>? ?? {};

    rawData.forEach((gradeKey, subjectMap) {
      final Map<String, List<ClassRoomItemModel>> subjects = {};

      if (subjectMap is Map<String, dynamic>) {
        subjectMap.forEach((subjectKey, classList) {
          if (classList is List) {
            subjects[subjectKey] = classList
                .map((e) => ClassRoomItemModel.fromJson(e))
                .toList();
          }
        });
      }

      parsedData[gradeKey] = subjects;
    });

    return GetClassesByGradeResponseModel(
      status: json['status'] ?? '',
      gradeId: json['grade_id'].toString(),
      data: parsedData,
    );
  }
}