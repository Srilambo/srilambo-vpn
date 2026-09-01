// Import must be at top in Dart
import 'package:srilambo_vpn/models/vpn_server.dart';

enum VpnStatus { disconnected, connecting, connected, disconnecting, error }

extension VpnStatusExtension on VpnStatus {
  String get label {
    switch (this) {
      case VpnStatus.disconnected:   return 'Not Protected';
      case VpnStatus.connecting:     return 'Connecting...';
      case VpnStatus.connected:      return 'Protected';
      case VpnStatus.disconnecting:  return 'Disconnecting...';
      case VpnStatus.error:          return 'Connection Failed';
    }
  }

  bool get isActive => this == VpnStatus.connected;
  bool get isLoading =>
      this == VpnStatus.connecting || this == VpnStatus.disconnecting;
}

class VpnConnectionState {
  final VpnStatus status;
  final VpnServer? connectedServer;
  final Duration? connectedDuration;
  final int? dataUploadedBytes;
  final int? dataDownloadedBytes;
  final String? errorMessage;

  const VpnConnectionState({
    this.status = VpnStatus.disconnected,
    this.connectedServer,
    this.connectedDuration,
    this.dataUploadedBytes,
    this.dataDownloadedBytes,
    this.errorMessage,
  });

  VpnConnectionState copyWith({
    VpnStatus? status,
    VpnServer? connectedServer,
    Duration? connectedDuration,
    int? dataUploadedBytes,
    int? dataDownloadedBytes,
    String? errorMessage,
  }) {
    return VpnConnectionState(
      status: status ?? this.status,
      connectedServer: connectedServer ?? this.connectedServer,
      connectedDuration: connectedDuration ?? this.connectedDuration,
      dataUploadedBytes: dataUploadedBytes ?? this.dataUploadedBytes,
      dataDownloadedBytes: dataDownloadedBytes ?? this.dataDownloadedBytes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  String get formattedDuration {
    if (connectedDuration == null) return '00:00:00';
    final h = connectedDuration!.inHours.toString().padLeft(2, '0');
    final m = (connectedDuration!.inMinutes % 60).toString().padLeft(2, '0');
    final s = (connectedDuration!.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  String get formattedDataUsage {
    final total = (dataUploadedBytes ?? 0) + (dataDownloadedBytes ?? 0);
    if (total < 1024) return '${total}B';
    if (total < 1024 * 1024) return '${(total / 1024).toStringAsFixed(1)}KB';
    return '${(total / 1024 / 1024).toStringAsFixed(2)}MB';
  }
}
