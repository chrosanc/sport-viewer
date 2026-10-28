import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:streamed_mobile/data/datasources/stream_datasource.dart';
import 'package:streamed_mobile/data/models/match_model.dart';
import 'package:streamed_mobile/data/models/stream_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StreamViewmodel extends ChangeNotifier {
  /// Dependencies
  final StreamDatasource dataSource = StreamDatasource();

  /// WebView controller
  WebViewController? webViewController;

  /// Data
  MatchModel? selectedMatch;
  Map<String, List<StreamModel>> streamsBySource = {}; // key = sourceId

  /// Selected values
  Map<String, int?> selectedStreams = {}; // key = sourceId, value = streamNo
  String? _selectedSourceId;
  String? get selectedSourceId => _selectedSourceId;

  /// States
  String _embedUrl = '';
  String get embedUrl => _embedUrl;
  bool isLoading = false;
  bool isFullscreen = false;
  String errorMessage = '';

  // ---------------------------------------------------------------------------
  // SET MATCH
  // ---------------------------------------------------------------------------

  set embedUrl(String value) {
    if (_embedUrl != value) {
      _embedUrl = value;
      print('EMBED URL : $embedUrl');
      notifyListeners();
    }
  }

  Future<void> setSelectedMatch(MatchModel match) async {
    selectedMatch = match;
    streamsBySource.clear();
    selectedStreams.clear();
    _embedUrl = '';
    _selectedSourceId = null;
    notifyListeners();

    if (match.sources != null && match.sources!.isNotEmpty) {
      isLoading = true;
      errorMessage = '';
      notifyListeners();
      try {
        for (final source in match.sources!) {
          await fetchStreams(source.id.toString(), source.source);
        }
        final firstSource = match.sources!.first.source;
        final firstList = streamsBySource[firstSource];
        if (firstList != null && firstList.isNotEmpty) {
          _embedUrl = firstList.first.embedUrl;
          selectedStreams[firstSource] = firstList.first.streamNo;
          _selectedSourceId = firstSource;
          await initializeWebView();
        }
      } catch (e) {
        errorMessage = 'Error fetching streams : $e';
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }

    // Ambil stream untuk source pertama
    if (match.sources != null && match.sources!.isNotEmpty) {
      final firstSource = match.sources!.first;
      await fetchStreams(firstSource.id.toString(), firstSource.source);
    }
  }

  // ---------------------------------------------------------------------------
  // SELECT STREAM
  // ---------------------------------------------------------------------------

  Future<void> selectStream(int streamNo, String source) async {
    final sourceStreams = streamsBySource[source];

    if (sourceStreams == null || sourceStreams.isEmpty) {
      print(' No stream for source : $source');
      return;
    }

    final selectedStream = sourceStreams.firstWhere(
      (s) => s.streamNo == streamNo,
      orElse: () => sourceStreams.first,
    );

    final newEmbedUrl = selectedStream.embedUrl;
    print('🔁 Changing Stream to $streamNo | URL : $newEmbedUrl');
    // Update WebView dengan URL baru
    if (webViewController != null) {
      await webViewController!.loadRequest(Uri.parse(newEmbedUrl));
    } else {
      print('🧭 WebViewController not Ready');
      embedUrl = newEmbedUrl;
      await initializeWebView();
    }
    await refreshPage();
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // FETCH STREAMS
  // ---------------------------------------------------------------------------

  Future<void> refreshPage() async {
    if (selectedMatch == null) return;

    isLoading = true;
    notifyListeners();

    try {
      // Panggil ulang semua sumber stream
      for (final source in selectedMatch!.sources!) {
        await fetchStreams(source.id.toString(), source.source);
      }

      print('✅ Page refreshed, all streams reloaded.');
    } catch (e) {
      errorMessage = 'Error refreshing page: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchStreams(String matchId, String source) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      final result = await dataSource.fetchStreamsByMatchId(matchId, source);
      streamsBySource[source] = result;

      print('Streams for Source : $source (${result.length} streams)');
      for (var s in result) {
        print('- Stream No ${s.streamNo} , Embed URL : ${s.embedUrl}');
      }

      print('\n----- All Streams By Source -----');
      streamsBySource.forEach((key, value) {
        print('Source: $key → ${value.length} streams');
        for (var v in value) {
          print('   • Stream ${v.streamNo} | ${v.embedUrl}');
        }
      });
      print('---------------------------------\n');

      if (result.isNotEmpty) {
        _embedUrl = result.first.embedUrl;
        selectedStreams[source] = result.first.streamNo;
        _selectedSourceId = source;
        await initializeWebView();
      }
    } catch (e) {
      errorMessage = 'Error fetching streams: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ---------------------------------------------------------------------------
  // WEBVIEW
  // ---------------------------------------------------------------------------

  Future<void> initializeWebView() async {
    if (embedUrl.isEmpty) return;

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..addJavaScriptChannel(
        'Fullscreen',
        onMessageReceived: _handleFullscreenMessage,
      )
      ..setNavigationDelegate(
        NavigationDelegate(onNavigationRequest: _handleNavigationRequest),
      )
      ..loadRequest(Uri.parse(embedUrl));
  }

  NavigationDecision _handleNavigationRequest(NavigationRequest nav) {
    final uri = Uri.tryParse(nav.url);
    if (uri == null) return NavigationDecision.prevent;

    final isAllowedDomain =
        uri.host.contains('strmfree.st') || uri.path.endsWith('.m3u8');
    return isAllowedDomain
        ? NavigationDecision.navigate
        : NavigationDecision.prevent;
  }

  Future<void> _handleFullscreenMessage(JavaScriptMessage msg) async {
    if (msg.message == 'enter') {
      isFullscreen = true;
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      isFullscreen = false;
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // HELPERS
  // ---------------------------------------------------------------------------

  bool isStreamSelected(String source, int streamNo) {
    final isCurrentSource =
        _selectedSourceId?.toLowerCase() == source.toLowerCase();
    final selectedStreamNo = selectedStreams[source];
    return isCurrentSource && selectedStreamNo == streamNo;
  }

  void resetData() {
    webViewController = null;
    selectedMatch = null;
    streamsBySource.clear();
    selectedStreams.clear();
    _selectedSourceId = null;
    _embedUrl = '';
    isLoading = false;
    isFullscreen = false;
    errorMessage = '';
    notifyListeners();
  }
}
