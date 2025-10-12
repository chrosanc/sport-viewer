class SportModel {
  final String id;
  final String name;

  SportModel({required this.id, required this.name});

  factory SportModel.fromJson(Map<String, dynamic> json) {
    return SportModel(id: json['id'] as String, name: json['name'] as String);
  }
}
