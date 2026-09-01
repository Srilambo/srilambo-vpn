import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:srilambo_vpn/services/storage_service.dart';
import 'package:srilambo_vpn/theme/app_theme.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _killSwitch = StorageService.getKillSwitch();
  bool _autoConnect = StorageService.getAutoConnect();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDeep,
      appBar: AppBar(
        backgroundColor: AppTheme.bgCard,
        title: const Text('Settings', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          _SettingsSection(title: 'VPN Protection', children: [
            _ToggleTile(
              icon: Icons.block_rounded,
              iconColor: AppTheme.vpnRed,
              title: 'Kill Switch',
              subtitle: 'Block internet if VPN drops',
              value: _killSwitch,
              onChanged: (v) async {
                await StorageService.setKillSwitch(v);
                setState(() => _killSwitch = v);
              },
            ),
            _ToggleTile(
              icon: Icons.bolt_rounded,
              iconColor: AppTheme.vpnGreen,
              title: 'Auto-Connect',
              subtitle: 'Connect VPN on app launch',
              value: _autoConnect,
              onChanged: (v) async {
                await StorageService.setAutoConnect(v);
                setState(() => _autoConnect = v);
              },
            ),
          ]),

          const SizedBox(height: 16),
          _SettingsSection(title: 'Protocol', children: [
            _NavTile(
              icon: Icons.cable_rounded,
              iconColor: AppTheme.vpnBlue,
              title: 'VPN Protocol',
              subtitle: 'WireGuard (recommended)',
              onTap: () {},
            ),
            _NavTile(
              icon: Icons.dns_rounded,
              iconColor: AppTheme.vpnBlue,
              title: 'DNS Settings',
              subtitle: 'Cloudflare 1.1.1.1',
              onTap: () {},
            ),
          ]),

          const SizedBox(height: 16),
          _SettingsSection(title: 'Account', children: [
            _NavTile(
              icon: Icons.upgrade_rounded,
              iconColor: Color(0xFFFFD600),
              title: 'Upgrade to Premium',
              subtitle: 'Access all servers & features',
              onTap: () {},
            ),
            _NavTile(
              icon: Icons.logout_rounded,
              iconColor: AppTheme.vpnRed,
              title: 'Sign Out',
              subtitle: 'Log out of your account',
              onTap: () async {
                await StorageService.clear();
                if (context.mounted) context.go('/login');
              },
            ),
          ]),

          const SizedBox(height: 16),
          _SettingsSection(title: 'About', children: [
            _NavTile(
              icon: Icons.info_outline_rounded,
              iconColor: AppTheme.textSecondary,
              title: 'App Version',
              subtitle: '1.0.0',
              onTap: () {},
            ),
            _NavTile(
              icon: Icons.privacy_tip_outlined,
              iconColor: AppTheme.textSecondary,
              title: 'Privacy Policy',
              subtitle: 'View our privacy policy',
              onTap: () {},
            ),
          ]),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.bgCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF1E2A45)),
          ),
          child: Column(
            children: List.generate(children.length, (i) {
              return Column(
                children: [
                  children[i],
                  if (i < children.length - 1)
                    const Divider(height: 1, color: Color(0xFF1E2A45), indent: 56),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w500)),
                Text(subtitle, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppTheme.vpnGreen,
          ),
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _NavTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w500)),
                  Text(subtitle, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppTheme.textHint),
          ],
        ),
      ),
    );
  }
}
