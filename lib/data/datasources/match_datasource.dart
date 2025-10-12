import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:streamed_mobile/data/models/match_model.dart';

class MatchDatasource {
  final List<String> urls = [
    'https://streamed.pk/api/',
    'https://streami.su/api/',
    'https://streamed.st/api/',
  ];

  Future<List<MatchModel>> fetchAllMatches() async {
    Exception? lastError;

    for (final baseUrl in urls) {
      try {
        final matches = await _fetchFromUrl(baseUrl);
        if (matches.isNotEmpty) {
          return matches;
        } else {
          print('No data from $baseUrl, trying next...');
        }
      } catch (e) {
        lastError = Exception('Failed to fetch from $baseUrl: $e');
        print('Error fetching from $baseUrl: $e');
      }
    }
    throw lastError ?? Exception('Failed to fetch matches from all sources.');
  }

  Future<List<MatchModel>> _fetchFromUrl(String baseUrl) async {
    final response = await http.get(Uri.parse('${baseUrl}matches/live'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      if (data is List) {
        return data.map<MatchModel>((e) => MatchModel.fromJson(e)).toList();
      } else {
        throw Exception('Unexpected data format');
      }
    } else {
      throw Exception('Failed to load matches : ${response.statusCode}');
    }
  }
}
