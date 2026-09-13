import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Invisible kiosk hotspot: press-and-hold the corner for [hold] to fire
/// [onTrigger] (admin entry). Long-press based, so finger drift within touch
/// slop no longer cancels the hold (the old tap-timer did on any
/// `onTapCancel`). Slightly inset from the screen edges so system edge
/// gestures don't steal the touch. Haptic tick on fire, no visual trace —
/// lifting the finger early cancels. Testable via [hold] (holds shorter
/// than the long-press timeout fire at recognition instead).
class CornerHotspot extends StatefulWidget {
  const CornerHotspot({
    super.key,
    required this.onTrigger,
    this.hold = const Duration(seconds: 2),
    this.size = 96,
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

  void _fire() {
    _timer = null;
    // Best-effort: haptics must never break admin entry (or tests).
    unawaited(
      HapticFeedback.lightImpact().then<void>((_) {}, onError: (_) {}),
    );
    widget.onTrigger();
  }

  @override
  void dispose() {
    _cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The long-press recognizer accepts the press (~500ms, slop-tolerant),
    // then we hold for the remainder of [hold]. Total hold time is [hold].
    final remaining = widget.hold - kLongPressTimeout;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onLongPressStart: (_) {
          _cancel();
          if (remaining <= Duration.zero) {
            _fire();
          } else {
            _timer = Timer(remaining, _fire);
          }
        },
        onLongPressEnd: (_) => _cancel(),
        onLongPressCancel: _cancel,
        child: SizedBox(width: widget.size, height: widget.size),
      ),
    );
  }
}
