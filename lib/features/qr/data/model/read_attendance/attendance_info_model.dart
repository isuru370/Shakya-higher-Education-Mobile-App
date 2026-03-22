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
      totalThisMonth: json['attendance_count_this_month_total'],
      countForThisClass: json['attendance_count_for_this_class'],
      currentMonth: json['current_month'],
    );
  }
}
