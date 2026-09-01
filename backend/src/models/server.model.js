const mongoose = require('mongoose');

const vpnServerSchema = new mongoose.Schema(
  {
    name: { type: String, required: true, trim: true },
    countryCode: { type: String, required: true, uppercase: true, length: 2 },
    countryName: { type: String, required: true },
    flagEmoji: { type: String, default: '🌐' },
    host: { type: String, required: true },
    port: { type: Number, default: 51820 },
    publicKey: { type: String, required: true },
    // Private key stored securely — never sent to client
    privateKey: { type: String, required: true, select: false },
    isPremium: { type: Boolean, default: false },
    isActive: { type: Boolean, default: true },
    // Live stats (updated periodically)
    ping: { type: Number, default: null },
    loadPercent: { type: Number, default: 0, min: 0, max: 100 },
    connectedUsers: { type: Number, default: 0 },
  },
  { timestamps: true }
);

// Never expose private key
vpnServerSchema.methods.toPublicJSON = function () {
  const obj = this.toObject();
  delete obj.privateKey;
  delete obj.__v;
  return obj;
};

module.exports = mongoose.model('VpnServer', vpnServerSchema);
