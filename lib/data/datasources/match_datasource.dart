import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:streamed_mobile/data/models/match_model.dart';

const apiBaseUrl = 'https://strmfree.st/api/v1/';

class MatchDatasource {
  Future<List<MatchModel>> fetchAllMatches() async {
    final response = await http.get(Uri.parse('${apiBaseUrl}streams'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load matches : ${response.statusCode}');
    }
    final streams = jsonDecode(response.body)['streams'];
    if (streams is! List) throw Exception('Unexpected data format');
    return streams
        .where((e) => (e['live_sources'] as List?)?.isNotEmpty ?? false)
        .map<MatchModel>((e) => MatchModel.fromJson(e))
        .toList();
  }
}
