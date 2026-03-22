class QuickPhotoModel {
  final String customId;
  final String quickImg;
  final int gradeId;

  QuickPhotoModel({
    required this.customId,
    required this.quickImg,
    required this.gradeId,
  });

  factory QuickPhotoModel.fromJson(Map<String, dynamic> json) {
    return QuickPhotoModel(
      customId: json["data"]["custom_id"],
      quickImg: json["data"]["quick_img"],
      gradeId: json["data"]["grade_id"],
    );
  }
}
