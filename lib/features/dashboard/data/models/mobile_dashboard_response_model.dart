import 'student_mini_model.dart';
import 'today_class_model.dart';

class MobileDashboardResponseModel {
  final bool status;
  final DashboardDataModel data;

  MobileDashboardResponseModel({required this.status, required this.data});

  factory MobileDashboardResponseModel.fromJson(Map<String, dynamic> json) {
    return MobileDashboardResponseModel(
      status: json['status'],
      data: DashboardDataModel.fromJson(json['data']),
    );
  }
}

class DashboardDataModel {
  final double dailyCollection;
  final int todayRegisteredStudentsCount;
  final List<StudentMiniModel> todayRegisteredStudents;
  final List<TodayClassModel> todayClasses;

  DashboardDataModel({
    required this.dailyCollection,
    required this.todayRegisteredStudentsCount,
    required this.todayRegisteredStudents,
    required this.todayClasses,
  });

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) {
    return DashboardDataModel(
      dailyCollection:
          double.tryParse(json['daily_collection'].toString()) ?? 0.0,
      todayRegisteredStudentsCount:
          json['today_registered_students_count'] ?? 0,
      todayRegisteredStudents: (json['today_registered_students'] as List)
          .map((e) => StudentMiniModel.fromJson(e))
          .toList(),
      todayClasses: (json['today_classes'] as List)
          .map((e) => TodayClassModel.fromJson(e))
          .toList(),
    );
  }
}
