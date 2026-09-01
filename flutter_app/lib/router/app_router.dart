import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:srilambo_vpn/providers/app_providers.dart';
import 'package:srilambo_vpn/screens/splash_screen.dart';
import 'package:srilambo_vpn/screens/login_screen.dart';
import 'package:srilambo_vpn/screens/register_screen.dart';
import 'package:srilambo_vpn/screens/home_screen.dart';
import 'package:srilambo_vpn/screens/server_list_screen.dart';
import 'package:srilambo_vpn/screens/settings_screen.dart';
import 'package:srilambo_vpn/screens/profile_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final isLoggedInAsync = ref.watch(isLoggedInProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = isLoggedInAsync.valueOrNull;
      final isOnAuth = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (isLoggedIn == null) return '/'; // still loading
      if (!isLoggedIn && !isOnAuth) return '/login';
      if (isLoggedIn && isOnAuth) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
      GoRoute(path: '/servers', builder: (_, __) => const ServerListScreen()),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
      GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
    ],
  );
});
