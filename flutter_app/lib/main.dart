import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srilambo_vpn/theme/app_theme.dart';
import 'package:srilambo_vpn/router/app_router.dart';
import 'package:srilambo_vpn/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const ProviderScope(child: SrilamboVPNApp()));
}

class SrilamboVPNApp extends ConsumerWidget {
  const SrilamboVPNApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'Srilambo VPN',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
