class ReadAttendanceRequestModel {
  final String customId;

  ReadAttendanceRequestModel({required this.customId});

  Map<String, dynamic> toQuery() {
    return {
      'custom_id': customId,
    };
  }
}
