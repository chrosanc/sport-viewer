import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:streamed_mobile/data/datasources/match_datasource.dart';
import 'package:streamed_mobile/data/models/match_model.dart';

void main() {
  group('MatchRemoteDatasourceTest', () {
    test('fetchAllMatches returns MatchModel on successful response', () async {
      final mockClient = MockClient((request) async {
        final mockJson = {
          "id": "benfica-vs-rio-ave-2283330",
          "title": "Benfica vs Rio Ave",
          "category": "football",
          "date": 1758654900000,
          "poster": "/api/images/proxy/poster.webp",
          "popular": true,
          "teams": {
            "home": {"name": "Benfica", "badge": "badge_home"},
            "away": {"name": "Rio Ave", "badge": "badge_away"},
          },
          "sources": [
            {"source": "alpha", "id": "benfica-vs-rio-ave"},
            {"source": "charlie", "id": "benfica-vs-rio-ave-1396238"},
          ],
        };
        return http.Response(jsonEncode([mockJson]), 200);
      });
      final datasource = StreamedDatasource(client: mockClient);

      final result = await datasource.fetchAllMatches();

      expect(result, isA<List<MatchModel>>());
      expect(result.length, 1);
      expect(result.first.id, "benfica-vs-rio-ave-2283330");
      expect(result.first.home.name, "Benfica");
      expect(result.first.away.name, "Rio Ave");
    });
  });
}
