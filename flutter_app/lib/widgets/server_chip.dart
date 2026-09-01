import 'package:flutter/material.dart';
import 'package:srilambo_vpn/models/vpn_server.dart';
import 'package:srilambo_vpn/theme/app_theme.dart';

/// Compact chip showing currently selected server on home screen
class ServerChip extends StatelessWidget {
  final VpnServer? server;
  final VoidCallback onTap;

  const ServerChip({super.key, required this.server, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          gradient: AppTheme.cardGradient,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF1E2A45)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.bgElevated,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: server != null
                    ? Text(server!.flagEmoji, style: const TextStyle(fontSize: 22))
                    : const Icon(Icons.language_rounded, color: AppTheme.textSecondary),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    server?.name ?? 'Select a Server',
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    server?.countryName ?? 'Tap to choose a VPN location',
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.vpnGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.vpnGreen.withValues(alpha: 0.3)),
              ),
              child: const Text(
                'CHANGE',
                style: TextStyle(
                  color: AppTheme.vpnGreen,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
