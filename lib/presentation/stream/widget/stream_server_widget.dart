import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:streamed_mobile/app/utils/capitalize_text.dart';
import 'package:streamed_mobile/presentation/stream/stream_viewmodel.dart';
import 'package:streamed_mobile/presentation/stream/widget/stream_select_widget.dart';

class StreamServerWidget extends StatelessWidget {
  final String title;
  final String sourceId; // unik untuk tiap sumber

  const StreamServerWidget({
    Key? key,
    required this.title,
    required this.sourceId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<StreamViewmodel>(context);

    // Ambil list stream dari Map sesuai sourceId
    final sourceStreams = viewModel.streamsBySource[title] ?? [];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey, width: 0.3),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            CapitalizeText().capitalize(title),
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Divider(color: Colors.grey, thickness: 0.3),
          const SizedBox(height: 12),

          // Render list stream
          ...sourceStreams.map(
            (stream) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: StreamSelectWidget(
                isActive: viewModel.isStreamSelected(title, stream.streamNo),
                streamNo: stream.streamNo,
                isHD: stream.hd,
                onTap: () {
                  viewModel.selectStream(stream.streamNo, title);
                },
                source: stream.source,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
