class ReadTuteRequestModel {
  final String customId;

  ReadTuteRequestModel({required this.customId});

  Map<String, dynamic> toQuery() {
    return {'custom_id': customId};
  }
}
