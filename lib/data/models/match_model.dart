class MatchModel {
  final String id;
  final String title;
  final String category;
  final int date;
  String? poster;
  final bool popular;
  TeamModel? home;
  TeamModel? away;
  final List<SourcesModel>? sources;

  MatchModel({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    this.poster,
    required this.popular,
    this.home,
    this.away,
    this.sources,
  });

  /// Parses a StreamFree `/api/v1/streams` item.
  factory MatchModel.fromJson(Map<String, dynamic> json) {
    final key = json['stream_key'] ?? '';
    final thumb = json['thumbnail_url']?.toString();
    return MatchModel(
      id: key,
      title: json['name'] ?? '',
      category: json['category'] ?? '',
      date: ((json['match_timestamp'] ?? 0) as int) * 1000,
      // ponytail: thumbnail host streamfree.top often unreachable; same path served by strmfree.st.
      poster: thumb == null
          ? ''
          : Uri.parse(thumb).replace(host: 'strmfree.st').toString(),
      popular: ((json['viewers'] ?? 0) as int) > 0,
      home: json['team1'] == null ? null : TeamModel.fromJson(json['team1']),
      away: json['team2'] == null ? null : TeamModel.fromJson(json['team2']),
      sources: [SourcesModel(source: 'strmfree', id: key)],
    );
  }
}

class TeamModel {
  String? name;
  String? badge;
  TeamModel({this.name, this.badge});
  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(name: json['name'] ?? '', badge: json['logo'] ?? '');
  }
}

class SourcesModel {
  final String source;
  final String id;

  SourcesModel({required this.source, required this.id});
  factory SourcesModel.fromJson(Map<String, dynamic> json) {
    return SourcesModel(
      source: json['source'] as String,
      id: json['id'] as String,
    );
  }
}
