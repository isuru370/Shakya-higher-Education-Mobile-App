class TuteInfoModel {
  final bool hasTuteForThisMonth;
  final String currentMonth;

  TuteInfoModel({
    required this.hasTuteForThisMonth,
    required this.currentMonth,
  });

  factory TuteInfoModel.fromJson(Map<String, dynamic> json) {
    return TuteInfoModel(
      hasTuteForThisMonth: json['has_tute_for_this_month'],
      currentMonth: json['current_month'],
    );
  }
}
