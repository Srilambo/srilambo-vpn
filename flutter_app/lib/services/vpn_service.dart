import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:wireguard_flutter/wireguard_flutter.dart';
import 'package:srilambo_vpn/models/vpn_server.dart';
import 'package:srilambo_vpn/models/vpn_state.dart';
import 'package:srilambo_vpn/services/api_service.dart';

/// Wraps wireguard_flutter (v0.1.x) to manage connect/disconnect lifecycle,
/// expose status stream, and track live connection duration.
class VpnService extends ChangeNotifier {
  final ApiService _api;

  VpnConnectionState _state = const VpnConnectionState();
  VpnConnectionState get state => _state;

  Timer? _durationTimer;
  StreamSubscription<VpnStage>? _statusSub;
  DateTime? _connectedAt;

  VpnService(this._api) {
    _listenToVpnStage();
  }

  // ── Listen to WireGuard stage changes ─────────────────────
  void _listenToVpnStage() {
    _statusSub = WireGuardFlutter.instance.vpnStageSnapshot.listen((stage) {
      _onStageChanged(stage);
    });
  }

  void _onStageChanged(VpnStage stage) {
    VpnStatus status;
    switch (stage) {
      case VpnStage.connected:
        status = VpnStatus.connected;
        _connectedAt ??= DateTime.now();
        _startDurationTimer();
        break;
      case VpnStage.connecting:
      case VpnStage.authenticating:
      case VpnStage.reconnect:
      case VpnStage.preparing:
        status = VpnStatus.connecting;
        break;
      case VpnStage.disconnecting:
      case VpnStage.exiting:
        status = VpnStatus.disconnecting;
        break;
      case VpnStage.disconnected:
      case VpnStage.waitingConnection:
      case VpnStage.noConnection:
        status = VpnStatus.disconnected;
        _stopDurationTimer();
        _connectedAt = null;
        break;
      case VpnStage.denied:
        status = VpnStatus.error;
        _stopDurationTimer();
        break;
    }
    _state = _state.copyWith(status: status);
    notifyListeners();
  }


  // ── Connect ────────────────────────────────────────────────
  Future<bool> connect(VpnServer server) async {
    try {
      _state = _state.copyWith(
        status: VpnStatus.connecting,
        connectedServer: server,
        errorMessage: null,
      );
      notifyListeners();

      // Fetch WireGuard config string from backend
      final wgConfig = await _api.getWireGuardConfig(server.id);

      await WireGuardFlutter.instance.initialize(
        interfaceName: 'wg0',
      );

      await WireGuardFlutter.instance.startVpn(
        serverAddress: server.host,
        wgQuickConfig: wgConfig,
        providerBundleIdentifier:
            'com.srilambo.vpn.wireguard', // iOS NetworkExtension bundle ID
      );

      return true;
    } catch (e) {
      _state = _state.copyWith(
        status: VpnStatus.error,
        errorMessage: e.toString(),
      );
      notifyListeners();
      return false;
    }
  }

  // ── Disconnect ─────────────────────────────────────────────
  Future<void> disconnect() async {
    try {
      _state = _state.copyWith(status: VpnStatus.disconnecting);
      notifyListeners();
      await WireGuardFlutter.instance.stopVpn();
    } catch (e) {
      _state = _state.copyWith(
        status: VpnStatus.error,
        errorMessage: e.toString(),
      );
      notifyListeners();
    }
  }

  // ── Toggle ─────────────────────────────────────────────────
  Future<void> toggle(VpnServer server) async {
    if (_state.status == VpnStatus.connected) {
      await disconnect();
    } else if (_state.status == VpnStatus.disconnected ||
        _state.status == VpnStatus.error) {
      await connect(server);
    }
  }

  // ── Duration timer ─────────────────────────────────────────
  void _startDurationTimer() {
    _durationTimer?.cancel();
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_connectedAt != null) {
        _state = _state.copyWith(
          connectedDuration: DateTime.now().difference(_connectedAt!),
        );
        notifyListeners();
      }
    });
  }

  void _stopDurationTimer() {
    _durationTimer?.cancel();
    _durationTimer = null;
  }

  @override
  void dispose() {
    _statusSub?.cancel();
    _durationTimer?.cancel();
    super.dispose();
  }
}
