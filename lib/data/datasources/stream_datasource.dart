import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:streamed_mobile/data/datasources/match_datasource.dart';
import 'package:streamed_mobile/data/models/stream_model.dart';

class StreamDatasource {
  Future<List<StreamModel>> fetchStreamsByMatchId(
    String matchId,
    String source,
  ) async {
    final response = await http.get(Uri.parse('${apiBaseUrl}sources/$matchId'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load streams : ${response.statusCode}');
    }
    final live = jsonDecode(response.body)['sources'];
    if (live is! List) throw Exception('Unexpected data format');
    return [
      for (var i = 0; i < live.length; i++)
        StreamModel(
          id: matchId,
          streamNo: i + 1,
          language: '',
          hd: live[i].toString().contains('1080p'),
          embedUrl: live[i].toString(),
          source: source,
        ),
    ];
  }
}
