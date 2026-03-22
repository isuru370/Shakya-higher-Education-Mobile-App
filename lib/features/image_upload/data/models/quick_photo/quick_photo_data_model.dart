class QuickPhotoDataModel {
  final String customId;
  final String quickImg;
  final int gradeId;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  QuickPhotoDataModel({
    required this.customId,
    required this.quickImg,
    required this.gradeId,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory QuickPhotoDataModel.fromJson(Map<String, dynamic> json) {
    return QuickPhotoDataModel(
      customId: json["custom_id"],
      quickImg: json["quick_img"],
      gradeId: json["grade_id"],
      isActive: json["is_active"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }
}