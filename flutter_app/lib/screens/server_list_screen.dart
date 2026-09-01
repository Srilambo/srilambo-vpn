import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:srilambo_vpn/models/vpn_server.dart';
import 'package:srilambo_vpn/providers/app_providers.dart';
import 'package:srilambo_vpn/theme/app_theme.dart';

class ServerListScreen extends ConsumerStatefulWidget {
  const ServerListScreen({super.key});

  @override
  ConsumerState<ServerListScreen> createState() => _ServerListScreenState();
}

class _ServerListScreenState extends ConsumerState<ServerListScreen> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final serversAsync = ref.watch(serverListProvider);
    final selectedServer = ref.watch(selectedServerProvider);

    return Scaffold(
      backgroundColor: AppTheme.bgDeep,
      appBar: AppBar(
        backgroundColor: AppTheme.bgCard,
        title: const Text(
          'Choose Server',
          style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.textPrimary),
          onPressed: () => context.pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              onChanged: (v) => setState(() => _search = v.toLowerCase()),
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search servers...',
                hintStyle: const TextStyle(color: AppTheme.textHint),
                prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
                filled: true,
                fillColor: AppTheme.bgElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
      ),
      body: serversAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.vpnGreen)),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off_rounded, color: AppTheme.textHint, size: 48),
              const SizedBox(height: 16),
              Text('Failed to load servers', style: TextStyle(color: AppTheme.textSecondary)),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => ref.refresh(serverListProvider),
                child: const Text('Retry', style: TextStyle(color: AppTheme.vpnGreen)),
              ),
            ],
          ),
        ),
        data: (servers) {
          final filtered = _search.isEmpty
              ? servers
              : servers.where((s) =>
                  s.countryName.toLowerCase().contains(_search) ||
                  s.name.toLowerCase().contains(_search)).toList();

          // Separate free from premium
          final free = filtered.where((s) => !s.isPremium).toList();
          final premium = filtered.where((s) => s.isPremium).toList();

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              if (free.isNotEmpty) ...[
                _SectionHeader(title: 'Free Servers', count: free.length),
                ...free.map((s) => _ServerTile(
                  server: s,
                  isSelected: selectedServer?.id == s.id,
                  onTap: () {
                    ref.read(selectedServerProvider.notifier).state = s;
                    context.pop();
                  },
                )),
              ],
              if (premium.isNotEmpty) ...[
                _SectionHeader(title: 'Premium Servers', count: premium.length, isPremium: true),
                ...premium.map((s) => _ServerTile(
                  server: s,
                  isSelected: selectedServer?.id == s.id,
                  onTap: () {
                    ref.read(selectedServerProvider.notifier).state = s;
                    context.pop();
                  },
                )),
              ],
              if (filtered.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 80),
                  child: Center(
                    child: Text('No servers found', style: TextStyle(color: AppTheme.textSecondary)),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final bool isPremium;

  const _SectionHeader({required this.title, required this.count, this.isPremium = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          if (isPremium) ...[
            const Icon(Icons.star_rounded, color: Color(0xFFFFD600), size: 16),
            const SizedBox(width: 6),
          ],
          Text(
            title,
            style: TextStyle(
              color: isPremium ? const Color(0xFFFFD600) : AppTheme.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.bgElevated,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text('$count', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
          ),
        ],
      ),
    );
  }
}

class _ServerTile extends StatelessWidget {
  final VpnServer server;
  final bool isSelected;
  final VoidCallback onTap;

  const _ServerTile({required this.server, required this.isSelected, required this.onTap});

  Color get _loadColor {
    final load = server.loadPercent ?? 0;
    if (load < 50) return AppTheme.vpnGreen;
    if (load < 80) return AppTheme.vpnOrange;
    return AppTheme.vpnRed;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTheme.cardGradient : null,
          color: isSelected ? null : AppTheme.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppTheme.vpnGreen.withValues(alpha: 0.6) : const Color(0xFF1E2A45),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: AppTheme.vpnGreen.withValues(alpha: 0.15), blurRadius: 12)]
              : null,
        ),
        child: Row(
          children: [
            // Flag emoji
            Text(server.flagEmoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 14),

            // Name + country
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    server.name,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(server.countryName, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                ],
              ),
            ),

            // Ping
            if (server.ping != null) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${server.ping}ms',
                    style: TextStyle(
                      color: server.ping! < 80 ? AppTheme.vpnGreen : AppTheme.vpnOrange,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (server.loadPercent != null)
                    Text(
                      'Load ${server.loadPercent}%',
                      style: TextStyle(color: _loadColor, fontSize: 10),
                    ),
                ],
              ),
              const SizedBox(width: 10),
            ],

            // Selected checkmark
            if (isSelected)
              Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppTheme.greenGradient,
                ),
                child: const Icon(Icons.check_rounded, size: 14, color: Colors.black),
              )
            else
              const Icon(Icons.chevron_right_rounded, color: AppTheme.textHint),
          ],
        ),
      ),
    );
  }
}
