import '../student_mini_model.dart';
import 'attendance_info_model.dart';
import 'ongoing_class_model.dart';
import 'payment_info_model.dart';
import 'student_student_class_model.dart';
import 'tute_info_model.dart';

class ReadAttendanceModel {
  final String categoryName;
  final String studentPackage;
  final String studentClassName;
  final StudentMiniModel student;
  final StudentStudentClassModel studentStudentStudentClass;
  final OngoingClassModel ongoingClass;
  final PaymentInfoModel? paymentInfo;
  final AttendanceInfoModel? attendanceInfo;
  final TuteInfoModel? tuteInfo;

  ReadAttendanceModel({
    required this.categoryName,
    required this.studentPackage,
    required this.studentClassName,
    required this.student,
    required this.studentStudentStudentClass,
    required this.ongoingClass,
    this.paymentInfo,
    this.attendanceInfo,
    this.tuteInfo,
  });

  factory ReadAttendanceModel.fromJson(Map<String, dynamic> json) {
    return ReadAttendanceModel(
      categoryName: json['category_name']?.toString() ?? '',
      studentPackage: json['student_package']?.toString() ?? '',
      studentClassName: json['student_class_name']?.toString() ?? '',
      student: StudentMiniModel.fromJson(
        json['student'] as Map<String, dynamic>? ?? {},
      ),
      studentStudentStudentClass: StudentStudentClassModel.fromJson(
        json['studentStudentStudentClass'] as Map<String, dynamic>? ?? {},
      ),
      ongoingClass: OngoingClassModel.fromJson(
        json['ongoing_class'] as Map<String, dynamic>? ?? {},
      ),
      paymentInfo: json['payment_info'] != null
          ? PaymentInfoModel.fromJson(
              json['payment_info'] as Map<String, dynamic>,
            )
          : null,
      attendanceInfo: json['attendance_info'] != null
          ? AttendanceInfoModel.fromJson(
              json['attendance_info'] as Map<String, dynamic>,
            )
          : null,
      tuteInfo: json['tute_info'] != null
          ? TuteInfoModel.fromJson(
              json['tute_info'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}