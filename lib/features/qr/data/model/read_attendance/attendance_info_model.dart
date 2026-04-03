class AttendanceInfoModel {
  final int totalThisMonth;
  final int countForThisClass;
  final String currentMonth;

  AttendanceInfoModel({
    required this.totalThisMonth,
    required this.countForThisClass,
    required this.currentMonth,
  });

  factory AttendanceInfoModel.fromJson(Map<String, dynamic> json) {
    return AttendanceInfoModel(
      totalThisMonth: json['attendance_count_this_month_total'] ?? 0,
      countForThisClass: json['attendance_count_for_this_class'] ?? 0,
      currentMonth: json['current_month']?.toString() ?? '',
    );
  }
}