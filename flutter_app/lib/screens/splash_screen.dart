import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:srilambo_vpn/providers/app_providers.dart';
import 'package:srilambo_vpn/theme/app_theme.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(isLoggedInProvider, (_, next) {
      next.whenData((loggedIn) {
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (context.mounted) {
            context.go(loggedIn ? '/home' : '/login');
          }
        });
      });
    });

    return Scaffold(
      backgroundColor: AppTheme.bgDeep,
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Shield logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppTheme.greenGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.vpnGreen.withValues(alpha: 0.4),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.shield_rounded,
                  size: 56,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              ShaderMask(
                shaderCallback: (bounds) =>
                    AppTheme.greenGradient.createShader(bounds),
                child: const Text(
                  'SRILAMBO VPN',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 3,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Secure • Private • Fast',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 60),
              const CircularProgressIndicator(
                color: AppTheme.vpnGreen,
                strokeWidth: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
