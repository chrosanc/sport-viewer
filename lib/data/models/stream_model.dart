class StreamModel {
  final String id;
  final int streamNo;
  final String language;
  final bool hd;
  final String embedUrl;
  final String source;

  StreamModel({
    required this.id,
    required this.streamNo,
    required this.language,
    required this.hd,
    required this.embedUrl,
    required this.source,
  });

  factory StreamModel.fromJson(Map<String,dynamic> json) {
    return StreamModel(
      id: json['id'] ?? '',
      streamNo: json['streamNo'] ?? '',
      language: json['language'] ?? '',
      hd: json['hd'] ?? '',
      embedUrl: json['embedUrl'] ?? '',
      source: json['source'] ?? '',
    );
  }
}