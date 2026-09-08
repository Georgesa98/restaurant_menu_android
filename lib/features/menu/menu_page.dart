import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/tenant_config.dart';

/// P0 placeholder kiosk page. P1 replaces the body with the category rail +
/// item cards fed by drift. Hidden admin entry: 5 taps on the title.
class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _taps = 0;

  void _onTitleTap() {
    _taps++;
    if (_taps >= 5) {
      _taps = 0;
      context.go('/admin/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final tenant = TenantConfig.current;
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: _onTitleTap,
          child: Text(tenant.name),
        ),
      ),
      body: Center(
        child: Text(
          'Menu • ${tenant.slug} (P0 scaffold)',
          textDirection: TextDirection.ltr,
        ),
      ),
    );
  }
}
