import '../student_mini_model.dart';
import 'attendance_info_model.dart';
import 'ongoing_class_model.dart';
import 'payment_info_model.dart';
import 'student_student_class_model.dart';
import 'tute_info_model.dart';

class ReadAttendanceModel {
  final String categoryName;
  final String studentClassName;
  final StudentMiniModel student;
  final StudentClassModel studentStudentStudentClass;
  final OngoingClassModel ongoingClass;
  final PaymentInfoModel? paymentInfo; // nullable
  final AttendanceInfoModel? attendanceInfo; // nullable
  final TuteInfoModel tuteInfo;

  ReadAttendanceModel({
    required this.categoryName,
    required this.studentClassName,
    required this.student,
    required this.studentStudentStudentClass,
    required this.ongoingClass,
    this.paymentInfo,
    this.attendanceInfo,
    required this.tuteInfo,
  });

  factory ReadAttendanceModel.fromJson(Map<String, dynamic> json) {
    return ReadAttendanceModel(
      categoryName: json['category_name'] ?? '',
      studentClassName: json['student_class_name'] ?? '',
      student: StudentMiniModel.fromJson(json['student']),
      studentStudentStudentClass: StudentClassModel.fromJson(
        json['studentStudentStudentClass'],
      ),
      ongoingClass: OngoingClassModel.fromJson(json['ongoing_class']),
      paymentInfo: json['payment_info'] != null
          ? PaymentInfoModel.fromJson(json['payment_info'])
          : null,
      attendanceInfo: json['attendance_info'] != null
          ? AttendanceInfoModel.fromJson(json['attendance_info'])
          : null,
      tuteInfo: TuteInfoModel.fromJson(json['tute_info']),
    );
  }
}
