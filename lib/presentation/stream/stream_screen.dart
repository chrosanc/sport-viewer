import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:streamed_mobile/app/utils/capitalize_text.dart';
import 'package:streamed_mobile/presentation/stream/stream_viewmodel.dart';
import 'package:streamed_mobile/presentation/stream/widget/stream_select_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StreamScreen extends StatefulWidget {
  const StreamScreen({Key? key}) : super(key: key);

  @override
  _StreamScreenState createState() => _StreamScreenState();
}

class _StreamScreenState extends State<StreamScreen> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<StreamViewmodel>(context);

    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.embedUrl.isEmpty) {
      return PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          vm.resetData();
        },
        child: Center(
          child: Text(
            'Cannot Load Stream',
            style: GoogleFonts.inter(
              color: Colors.grey,
              decoration: TextDecoration.none,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        vm.resetData();
      },
      child: OrientationBuilder(
        builder: (context, orientation) {
          final isLandscape = orientation == Orientation.landscape;

          return Scaffold(
            backgroundColor: Colors.black,
            body: isLandscape
                ? SizedBox.expand(
                    child: WebViewWidget(controller: vm.webViewController!),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      await vm.refreshPage();
                    },
                    child: SafeArea(
                      child: Stack(
                        children: [
                          /// --- Bagian scrollable (konten di bawah video)
                          Padding(
                            padding: EdgeInsets.only(
                              top:
                                  MediaQuery.of(context).size.width * (9 / 16) +
                                  16, // tinggi video
                            ),
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      vm.selectedMatch?.title ?? 'No Title',
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      CapitalizeText().capitalize(
                                        vm.selectedMatch?.category ??
                                            'No Category',
                                      ),
                                      style: GoogleFonts.inter(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Available Streams',
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 12),

                                    if (vm.streamsBySource.values.every(
                                      (l) => l.isEmpty,
                                    ))
                                      Text(
                                        'No streams available',
                                        style: GoogleFonts.inter(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    for (final s
                                        in vm.streamsBySource.values.expand(
                                          (l) => l,
                                        ))
                                      StreamSelectWidget(
                                        streamNo: s.streamNo,
                                        isHD: s.hd,
                                        source: s.source,
                                        isActive: vm.isStreamSelected(
                                          s.source,
                                          s.streamNo,
                                        ),
                                        onTap: () => vm.selectStream(
                                          s.streamNo,
                                          s.source,
                                        ),
                                      ),

                                    const SizedBox(height: 50),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          /// --- WebView
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                                child: WebViewWidget(
                                  controller: vm.webViewController!,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}
