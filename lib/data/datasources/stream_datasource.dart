import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:streamed_mobile/data/models/stream_model.dart';

class StreamDatasource {
  final String url = 'https://streamed.pk/api/stream/';

  Future<List<StreamModel>> fetchStreamsByMatchId(String matchId, String source) async {
    final response = await http.get(
      Uri.parse('${url}$source/$matchId'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Response Stream : ${response.body}');
      if(data is List){
        return data.map<StreamModel>((e) => StreamModel.fromJson(e)).toList();
      } else {
        throw Exception('Unexpected data format');
      }
    } else {

      throw Exception('Failed to load streams : ${response.statusCode}');
    }
  }

  Future<List<StreamModel>> fetchStreamsSource(String source, String sourceId) async {
    final response = await http.get(
      Uri.parse('${url}$source/$sourceId'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Response : ${response.body}');
      if(data is List){
        return data.map<StreamModel>((e) => StreamModel.fromJson(e)).toList();
      } else {
        throw Exception('Unexpected data format');
      }
    } else {

      throw Exception('Failed to load streams : ${response.statusCode}');
    }
  }
}