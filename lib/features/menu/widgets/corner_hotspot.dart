import 'dart:async';

import 'package:flutter/material.dart';

/// Invisible kiosk hotspot: press-and-hold the corner for [hold] to fire
/// [onTrigger] (admin entry). Transparent, no ripple, no hint — lifting the
/// finger early cancels. Testable via [hold].
class CornerHotspot extends StatefulWidget {
  const CornerHotspot({
    super.key,
    required this.onTrigger,
    this.hold = const Duration(seconds: 2),
    this.size = 72,
  });

  final VoidCallback onTrigger;
  final Duration hold;
  final double size;

  @override
  State<CornerHotspot> createState() => _CornerHotspotState();
}

class _CornerHotspotState extends State<CornerHotspot> {
  Timer? _timer;

  void _cancel() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (_) {
        _cancel();
        _timer = Timer(widget.hold, () {
          _timer = null;
          widget.onTrigger();
        });
      },
      onTapUp: (_) => _cancel(),
      onTapCancel: _cancel,
      child: SizedBox(width: widget.size, height: widget.size),
    );
  }
}
