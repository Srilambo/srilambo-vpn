import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srilambo_vpn/models/user.dart';
import 'package:srilambo_vpn/models/vpn_server.dart';
import 'package:srilambo_vpn/models/vpn_state.dart';
import 'package:srilambo_vpn/services/api_service.dart';
import 'package:srilambo_vpn/services/storage_service.dart';
import 'package:srilambo_vpn/services/vpn_service.dart';

// ── Service providers ──────────────────────────────────────────────────────────
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final vpnServiceProvider = ChangeNotifierProvider<VpnService>((ref) {
  return VpnService(ref.watch(apiServiceProvider));
});

// ── VPN state (derived from VpnService) ───────────────────────────────────────
final vpnStateProvider = Provider<VpnConnectionState>((ref) {
  return ref.watch(vpnServiceProvider).state;
});

// ── Selected server ────────────────────────────────────────────────────────────
final selectedServerProvider = StateProvider<VpnServer?>((ref) => null);

// ── Server list ────────────────────────────────────────────────────────────────
final serverListProvider = FutureProvider<List<VpnServer>>((ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.getServers();
});

// ── Auth providers ─────────────────────────────────────────────────────────────
final isLoggedInProvider = FutureProvider<bool>((ref) async {
  final token = await StorageService.getToken();
  return token != null;
});

final currentUserProvider = FutureProvider<User?>((ref) async {
  final isLoggedIn = await ref.watch(isLoggedInProvider.future);
  if (!isLoggedIn) return null;
  return ref.watch(apiServiceProvider).getProfile();
});
