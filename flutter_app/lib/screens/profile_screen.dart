import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:srilambo_vpn/providers/app_providers.dart';
import 'package:srilambo_vpn/services/storage_service.dart';
import 'package:srilambo_vpn/theme/app_theme.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppTheme.bgDeep,
      appBar: AppBar(
        backgroundColor: AppTheme.bgCard,
        title: const Text('Profile', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.vpnGreen)),
        error: (_, __) => const Center(child: Text('Failed to load profile', style: TextStyle(color: AppTheme.textSecondary))),
        data: (user) => user == null
            ? const Center(child: Text('Not logged in'))
            : ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  // Avatar
                  Center(
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppTheme.greenGradient,
                      ),
                      child: Center(
                        child: Text(
                          user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(user.name, style: Theme.of(context).textTheme.headlineMedium),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Text(user.email, style: const TextStyle(color: AppTheme.textSecondary)),
                  ),
                  const SizedBox(height: 16),

                  // Plan badge
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: user.isPremium
                            ? const LinearGradient(colors: [Color(0xFFFFD600), Color(0xFFFF9100)])
                            : null,
                        color: user.isPremium ? null : AppTheme.bgElevated,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            user.isPremium ? Icons.star_rounded : Icons.lock_open_rounded,
                            size: 16,
                            color: user.isPremium ? Colors.black : AppTheme.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            user.isPremium ? 'Premium Plan' : 'Free Plan',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: user.isPremium ? Colors.black : AppTheme.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),

                  if (!user.isPremium) ...[
                    // Upgrade banner
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1A2A10), Color(0xFF0F1629)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.vpnGreen.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Upgrade to Premium', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w700, fontSize: 16)),
                                const SizedBox(height: 4),
                                Text('Unlock all servers & features', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.vpnGreen,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text('Upgrade', style: TextStyle(fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Sign out
                  OutlinedButton.icon(
                    onPressed: () async {
                      await StorageService.clear();
                      if (context.mounted) context.go('/login');
                    },
                    icon: const Icon(Icons.logout_rounded, color: AppTheme.vpnRed),
                    label: const Text('Sign Out', style: TextStyle(color: AppTheme.vpnRed)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppTheme.vpnRed.withValues(alpha: 0.4)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
