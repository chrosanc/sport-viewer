import 'package:flutter_test/flutter_test.dart';
import 'package:streamed_mobile/data/models/match_model.dart';

void main() {
  test('MatchModel parses StreamFree stream item', () {
    final m = MatchModel.fromJson({
      'name': 'Ghana vs England',
      'category': 'soccer',
      'stream_key': 'ghana-vs-england',
      'match_timestamp': 1782244800,
      'viewers': 3,
      'thumbnail_url': 'https://streamfree.top/thumbnails/soccer_ghana-vs-england',
      'team1': {'name': 'Ghana', 'logo': 'g.png'},
      'team2': {'name': 'England', 'logo': 'e.png'},
    });
    expect(m.id, 'ghana-vs-england');
    expect(m.title, 'Ghana vs England');
    expect(m.date, 1782244800000);
    expect(m.poster, 'https://strmfree.st/thumbnails/soccer_ghana-vs-england');
    expect(m.home!.badge, 'g.png');
    expect(m.sources!.single.id, 'ghana-vs-england');
  });
}
