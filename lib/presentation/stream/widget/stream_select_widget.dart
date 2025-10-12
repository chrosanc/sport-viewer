import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StreamSelectWidget extends StatefulWidget {
  final String source;
  final int streamNo;
  final bool isActive;
  final bool isHD;
  final Function() onTap;

  const StreamSelectWidget({
    Key? key,
    required this.streamNo,
    required this.isHD,
    required this.onTap,
    required this.source, required this.isActive,
  }) : super(key: key);

  @override
  State<StreamSelectWidget> createState() => _StreamSelectWidgetState();
}

class _StreamSelectWidgetState extends State<StreamSelectWidget> {
  bool? _isSelectedLocal;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: widget.isActive ? Colors.red : Colors.grey),
          color: widget.isActive
              ? Colors.red.withOpacity(0.1)
              : Colors.transparent,
        ),
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              widget.isHD ? Icons.hd : Icons.sd,
              size: 32,
              color: widget.isHD ? Colors.red : Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Stream ${widget.streamNo}',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: widget.isActive ? FontWeight.bold : FontWeight.w400,
                ),
              ),
            ),
            if (widget.isActive)
              const Icon(Icons.check_circle, color: Colors.red, size: 20),
          ],
        ),
      ),
    );
  }
}
