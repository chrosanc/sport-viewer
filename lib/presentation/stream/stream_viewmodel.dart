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
      await _fetchAllSources();
      // Auto-select first source that actually has streams.
      for (final source in match.sources!) {
        final list = streamsBySource[source.source];
        if (list != null && list.isNotEmpty) {
          _embedUrl = list.first.embedUrl;
          selectedStreams[source.source] = list.first.streamNo;
          _selectedSourceId = source.source;
          await initializeWebView();
          break;
        }
      }
      isLoading = false;
      notifyListeners();
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

    selectedStreams[source] = selectedStream.streamNo;
    _selectedSourceId = source;
    _embedUrl = selectedStream.embedUrl;
    notifyListeners();

    if (webViewController != null) {
      await webViewController!.loadRequest(Uri.parse(_embedUrl));
    } else {
      await initializeWebView();
      notifyListeners();
    }
  }

  // ---------------------------------------------------------------------------
  // FETCH STREAMS
  // ---------------------------------------------------------------------------

  /// Re-fetch stream lists without touching current selection or player.
  Future<void> refreshPage() async {
    if (selectedMatch?.sources == null) return;
    await _fetchAllSources();
    notifyListeners();
  }

  Future<void> _fetchAllSources() async {
    errorMessage = '';
    await Future.wait(
      selectedMatch!.sources!.map(
        (s) => fetchStreams(s.id.toString(), s.source),
      ),
    );
  }

  /// Fetch-only; one failing source must not break others.
  Future<void> fetchStreams(String matchId, String source) async {
    try {
      streamsBySource[source] = await dataSource.fetchStreamsByMatchId(
        matchId,
        source,
      );
    } catch (e) {
      errorMessage = 'Error fetching streams ($source): $e';
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
