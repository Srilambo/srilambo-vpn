// ─── Data models ──────────────────────────────────────────────────────────────
// lib/models/vpn_server.dart

class VpnServer {
  final String id;
  final String name;
  final String countryCode;
  final String countryName;
  final String flagEmoji;
  final String host;
  final int port;
  final String publicKey;
  final int? ping;           // ms
  final int? loadPercent;    // 0-100
  final bool isPremium;

  const VpnServer({
    required this.id,
    required this.name,
    required this.countryCode,
    required this.countryName,
    required this.flagEmoji,
    required this.host,
    required this.port,
    required this.publicKey,
    this.ping,
    this.loadPercent,
    this.isPremium = false,
  });

  factory VpnServer.fromJson(Map<String, dynamic> json) {
    return VpnServer(
      id: json['_id'] as String,
      name: json['name'] as String,
      countryCode: json['countryCode'] as String,
      countryName: json['countryName'] as String,
      flagEmoji: json['flagEmoji'] as String? ?? '🌐',
      host: json['host'] as String,
      port: json['port'] as int? ?? 51820,
      publicKey: json['publicKey'] as String,
      ping: json['ping'] as int?,
      loadPercent: json['loadPercent'] as int?,
      isPremium: json['isPremium'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'countryCode': countryCode,
    'countryName': countryName,
    'flagEmoji': flagEmoji,
    'host': host,
    'port': port,
    'publicKey': publicKey,
    'ping': ping,
    'loadPercent': loadPercent,
    'isPremium': isPremium,
  };

  VpnServer copyWith({int? ping, int? loadPercent}) => VpnServer(
    id: id,
    name: name,
    countryCode: countryCode,
    countryName: countryName,
    flagEmoji: flagEmoji,
    host: host,
    port: port,
    publicKey: publicKey,
    ping: ping ?? this.ping,
    loadPercent: loadPercent ?? this.loadPercent,
    isPremium: isPremium,
  );
}
