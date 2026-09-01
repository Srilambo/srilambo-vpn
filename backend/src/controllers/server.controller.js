const VpnServer = require('../models/server.model');

// GET /api/servers — list all active servers (public info only)
exports.getServers = async (req, res, next) => {
  try {
    const servers = await VpnServer.find({ isActive: true }).sort({ isPremium: 1, ping: 1 });
    res.json({ servers: servers.map((s) => s.toPublicJSON()) });
  } catch (err) {
    next(err);
  }
};

// GET /api/servers/:id/config — return WireGuard config for authenticated user
// This generates a per-user WireGuard config with the server's public key
exports.getServerConfig = async (req, res, next) => {
  try {
    const server = await VpnServer.findById(req.params.id).select('+privateKey');
    if (!server || !server.isActive) {
      return res.status(404).json({ error: 'Server not found.' });
    }

    // Check premium restriction
    if (server.isPremium && req.user.plan !== 'premium') {
      return res.status(403).json({ error: 'This server requires a Premium plan.' });
    }

    // Build WireGuard quick config string
    // NOTE: In production, generate a real per-user keypair and add the peer to the WG server.
    // For demo/MVP, we use a shared config. Replace CLIENT_PRIVATE_KEY with real key gen.
    const wgConfig = buildWgConfig(server);

    res.json({ config: wgConfig });
  } catch (err) {
    next(err);
  }
};

function buildWgConfig(server) {
  const dns = process.env.WG_DNS || '1.1.1.1, 1.0.0.1';
  const allowedIPs = process.env.WG_ALLOWED_IPS || '0.0.0.0/0, ::/0';

  // NOTE: CLIENT_PRIVATE_KEY should be a real generated WireGuard private key
  // In production, call `wg genkey` on the server and store the peer's public key
  return `[Interface]
PrivateKey = CLIENT_PRIVATE_KEY_PLACEHOLDER
Address = 10.0.0.2/32
DNS = ${dns}

[Peer]
PublicKey = ${server.publicKey}
Endpoint = ${server.host}:${server.port}
AllowedIPs = ${allowedIPs}
PersistentKeepalive = 25
`;
}
