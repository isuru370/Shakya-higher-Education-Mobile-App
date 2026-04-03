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

    final dynamic rawDataDynamic = json['data'];

    if (rawDataDynamic is Map<String, dynamic>) {
      rawDataDynamic.forEach((gradeKey, subjectMap) {
        final Map<String, List<ClassRoomItemModel>> subjects = {};

        if (subjectMap is Map<String, dynamic>) {
          subjectMap.forEach((subjectKey, classList) {
            if (classList is List) {
              subjects[subjectKey] = classList
                  .whereType<Map<String, dynamic>>()
                  .map((e) => ClassRoomItemModel.fromJson(e))
                  .toList();
            }
          });
        }

        parsedData[gradeKey] = subjects;
      });
    }

    return GetClassesByGradeResponseModel(
      status: json['status']?.toString() ?? '',
      gradeId: json['grade_id']?.toString() ?? '',
      data: parsedData,
    );
  }
}
