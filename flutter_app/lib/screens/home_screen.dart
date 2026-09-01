
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:srilambo_vpn/models/vpn_state.dart';
import 'package:srilambo_vpn/providers/app_providers.dart';
import 'package:srilambo_vpn/theme/app_theme.dart';
import 'package:srilambo_vpn/widgets/server_chip.dart';
import 'package:srilambo_vpn/widgets/stats_row.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnState = ref.watch(vpnStateProvider);
    final selectedServer = ref.watch(selectedServerProvider);
    final vpnService = ref.read(vpnServiceProvider);

    final isConnected = vpnState.status == VpnStatus.connected;
    final isLoading = vpnState.status.isLoading;

    return Scaffold(
      backgroundColor: AppTheme.bgDeep,
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              // ── Top bar ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  children: [
                    // Logo
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppTheme.greenGradient,
                      ),
                      child: const Icon(Icons.shield_rounded, size: 20, color: Colors.black),
                    ),
                    const SizedBox(width: 10),
                    ShaderMask(
                      shaderCallback: (b) => AppTheme.greenGradient.createShader(b),
                      child: const Text(
                        'SRILAMBO VPN',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.person_outline_rounded, color: AppTheme.textSecondary),
                      onPressed: () => context.push('/profile'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings_outlined, color: AppTheme.textSecondary),
                      onPressed: () => context.push('/settings'),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // ── Status text ─────────────────────────────────
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          vpnState.status.label,
                          key: ValueKey(vpnState.status),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: _statusColor(vpnState.status),
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Status dot
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _statusColor(vpnState.status),
                              boxShadow: isConnected
                                  ? [BoxShadow(color: AppTheme.vpnGreen.withValues(alpha: 0.6), blurRadius: 8, spreadRadius: 2)]
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isConnected
                                ? 'Your connection is encrypted'
                                : 'Your connection is exposed',
                            style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),

                      // ── Main connect button ─────────────────────────
                      _ConnectButton(
                        isConnected: isConnected,
                        isLoading: isLoading,
                        onTap: () async {
                          if (selectedServer == null && !isConnected) {
                            context.push('/servers');
                            return;
                          }
                          if (selectedServer != null) {
                            await vpnService.toggle(selectedServer);
                          }
                        },
                      ),
                      const SizedBox(height: 36),

                      // ── Timer ────────────────────────────────────────
                      if (isConnected)
                        AnimatedOpacity(
                          opacity: isConnected ? 1 : 0,
                          duration: const Duration(milliseconds: 400),
                          child: Text(
                            vpnState.formattedDuration,
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w300,
                              color: AppTheme.textPrimary,
                              fontFamily: 'monospace',
                              letterSpacing: 4,
                            ),
                          ),
                        ),
                      if (isConnected) const SizedBox(height: 24),

                      // ── Stats row ────────────────────────────────────
                      if (isConnected)
                        StatsRow(state: vpnState),
                      if (isConnected) const SizedBox(height: 28),

                      // ── Server selector chip ─────────────────────────
                      ServerChip(
                        server: selectedServer,
                        onTap: () => context.push('/servers'),
                      ),
                      const SizedBox(height: 40),

                      // ── Security features row ────────────────────────
                      _SecurityFeatures(isConnected: isConnected),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(VpnStatus status) {
    switch (status) {
      case VpnStatus.connected: return AppTheme.connected;
      case VpnStatus.connecting:
      case VpnStatus.disconnecting: return AppTheme.connecting;
      case VpnStatus.error: return AppTheme.error;
      case VpnStatus.disconnected: return AppTheme.disconnected;
    }
  }
}

// ── Animated connect button ──────────────────────────────────────────────────
class _ConnectButton extends StatefulWidget {
  final bool isConnected;
  final bool isLoading;
  final VoidCallback onTap;

  const _ConnectButton({
    required this.isConnected,
    required this.isLoading,
    required this.onTap,
  });

  @override
  State<_ConnectButton> createState() => _ConnectButtonState();
}

class _ConnectButtonState extends State<_ConnectButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isLoading ? null : widget.onTap,
      child: AnimatedBuilder(
        animation: _pulseAnim,
        builder: (_, child) => Transform.scale(
          scale: widget.isConnected ? _pulseAnim.value : 1.0,
          child: child,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer ring
            AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.isConnected
                      ? AppTheme.vpnGreen.withValues(alpha: 0.25)
                      : AppTheme.textHint.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            // Middle ring
            AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.isConnected
                      ? AppTheme.vpnGreen.withValues(alpha: 0.35)
                      : AppTheme.textHint.withValues(alpha: 0.15),
                  width: 1.5,
                ),
              ),
            ),
            // Main button
            AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: widget.isConnected
                    ? AppTheme.greenGradient
                    : const LinearGradient(
                        colors: [Color(0xFF1C2540), Color(0xFF0F1629)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                boxShadow: [
                  BoxShadow(
                    color: widget.isConnected
                        ? AppTheme.vpnGreen.withValues(alpha: 0.45)
                        : Colors.black.withValues(alpha: 0.4),
                    blurRadius: widget.isConnected ? 40 : 20,
                    spreadRadius: widget.isConnected ? 5 : 2,
                  ),
                ],
                border: Border.all(
                  color: widget.isConnected
                      ? AppTheme.vpnGreen.withValues(alpha: 0.6)
                      : AppTheme.textHint.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: widget.isLoading
                  ? const CircularProgressIndicator(
                      color: AppTheme.vpnGreen,
                      strokeWidth: 2.5,
                    )
                  : Icon(
                      widget.isConnected
                          ? Icons.shield_rounded
                          : Icons.power_settings_new_rounded,
                      size: 52,
                      color: widget.isConnected
                          ? Colors.black
                          : AppTheme.textSecondary,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Security features ────────────────────────────────────────────────────────
class _SecurityFeatures extends StatelessWidget {
  final bool isConnected;
  const _SecurityFeatures({required this.isConnected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF1E2A45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Security Status', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, letterSpacing: 1)),
          const SizedBox(height: 16),
          _FeatureRow(
            icon: Icons.lock_rounded,
            label: 'AES-256 Encryption',
            active: isConnected,
          ),
          const SizedBox(height: 12),
          _FeatureRow(
            icon: Icons.dns_rounded,
            label: 'DNS Leak Protection',
            active: isConnected,
          ),
          const SizedBox(height: 12),
          _FeatureRow(
            icon: Icons.block_rounded,
            label: 'Kill Switch',
            active: isConnected,
          ),
          const SizedBox(height: 12),
          _FeatureRow(
            icon: Icons.visibility_off_rounded,
            label: 'IP Address Hidden',
            active: isConnected,
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _FeatureRow({required this.icon, required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: active ? AppTheme.vpnGreen.withValues(alpha: 0.15) : AppTheme.bgSurface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: active ? AppTheme.vpnGreen : AppTheme.textHint),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: TextStyle(color: AppTheme.textPrimary, fontSize: 14))),
        AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: active ? AppTheme.vpnGreen.withValues(alpha: 0.15) : AppTheme.bgSurface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            active ? 'ON' : 'OFF',
            style: TextStyle(
              color: active ? AppTheme.vpnGreen : AppTheme.textHint,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }
}
