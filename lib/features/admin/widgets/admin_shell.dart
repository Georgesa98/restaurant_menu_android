import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../auth/admin_auth.dart';

/// Wraps every admin screen: any interaction re-arms a 2-minute idle timer;
/// on fire the UI locks and returns to the kiosk. The sync session is
/// untouched — only the screens re-lock (password on re-entry).
class AdminShell extends ConsumerStatefulWidget {
  const AdminShell({
    super.key,
    required this.child,
    this.idleTimeout = const Duration(minutes: 2),
  });

  final Widget child;
  final Duration idleTimeout;

  @override
  ConsumerState<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends ConsumerState<AdminShell> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _arm();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _arm() {
    _timer?.cancel();
    _timer = Timer(widget.idleTimeout, _autoLock);
  }

  void _autoLock() {
    if (!mounted) return;
    ref.read(adminUnlockedProvider.notifier).lock();
    // No router in widget tests — go() only when one is present.
    GoRouter.maybeOf(context)?.go('/');
  }

  @override
  Widget build(BuildContext context) {
    // System back out of admin must re-lock: the idle timer is cancelled on
    // dispose, so without this a back-escape would stay unlocked forever and
    // re-entry would skip the password via the router redirect.
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) ref.read(adminUnlockedProvider.notifier).lock();
      },
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => _arm(),
        child: widget.child,
      ),
    );
  }
}
