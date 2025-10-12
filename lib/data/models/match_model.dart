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

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    final teams = json['teams'];
    TeamModel? homeTeam;
    TeamModel? awayTeam; 
    if (teams != null && teams['home'] != null && teams['away'] != null) {
      homeTeam = TeamModel.fromJson(teams['home'] ?? {});
      awayTeam = TeamModel.fromJson(teams['away'] ?? {});
    }
    return MatchModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      date: json['date'] as int,
      poster: json['poster']?.toString() ?? '',
      popular: (json['popular'] ?? false) as bool,
      home: homeTeam,
      away: awayTeam,
      sources: (json['sources'] as List?)
          ?.map((e) => SourcesModel.fromJson(e))
          .toList(),
    );
  }
}

class TeamModel {
  String? name;
  String? badge;
  TeamModel({this.name, this.badge});
  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      name: json['name'] ?? '' ,
      badge: json['badge'] ?? '',
    );
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
