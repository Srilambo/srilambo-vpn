# 🛡️ Srilambo VPN

A production-ready VPN app for **Android + iOS** built with Flutter and WireGuard.

## 📁 Project Structure

```
Android VPN App Development/
├── flutter_app/          ← Main Flutter app (Android + iOS)
│   ├── lib/
│   │   ├── main.dart
│   │   ├── theme/        ← Dark cybersecurity theme
│   │   ├── models/       ← VpnServer, User, VpnState
│   │   ├── services/     ← VpnService, ApiService, StorageService
│   │   ├── providers/    ← Riverpod providers
│   │   ├── router/       ← GoRouter with auth guard
│   │   ├── screens/      ← Splash, Login, Register, Home, Servers, Settings, Profile
│   │   └── widgets/      ← Reusable components
│   ├── android/          ← Android-specific config (VPN permissions)
│   └── ios/              ← iOS-specific config (Network Extension)
│
├── backend/              ← Node.js + Express + MongoDB API
│   └── src/
│       ├── index.js      ← Server entry point
│       ├── models/       ← User, VpnServer (Mongoose)
│       ├── controllers/  ← Auth, Server logic
│       ├── routes/       ← /api/auth, /api/servers, /api/sessions
│       └── middleware/   ← JWT auth guard
│
└── android/              ← Native Kotlin Android reference project
```

## 🚀 Getting Started

### 1. Backend Setup
```bash
cd backend
cp .env.example .env
# Edit .env with your MongoDB URI, JWT secret, WireGuard server details
npm install
npm run dev
```

### 2. Flutter App Setup
```bash
cd flutter_app
flutter pub get

# Run on Android
flutter run

# Run on iOS (requires macOS + Xcode)
flutter run -d ios
```

### 3. WireGuard Server Setup
Spin up a VPS (DigitalOcean/Linode/Hetzner) and install WireGuard:
```bash
# Ubuntu/Debian
apt install wireguard
wg genkey | tee server-private-key | wg pubkey > server-public-key
# Configure /etc/wireguard/wg0.conf
# Add your keys to backend/.env
```

## 📱 App Features
- ✅ One-tap WireGuard VPN connection
- ✅ Animated connect button with pulse effect
- ✅ Live connection timer + data usage stats
- ✅ Server list with search, ping, load indicators
- ✅ Free vs Premium server tiers
- ✅ Kill switch + auto-connect settings
- ✅ DNS leak protection via WireGuard config
- ✅ JWT authentication (login/register)
- ✅ Secure token storage (Keychain on iOS, EncryptedSharedPrefs on Android)

## 🔐 Security Stack
- WireGuard protocol (state-of-the-art, modern crypto)
- AES-256 equivalent via ChaCha20-Poly1305
- JWT with 30-day expiry
- bcrypt password hashing (cost factor 12)
- Rate limiting on all API endpoints
- Helmet.js security headers
- Private keys never sent to client

## 📋 iOS Notes
See `flutter_app/ios/IOS_SETUP.md` for:
- Network Extension target setup
- Required Xcode capabilities
- App Group configuration
- Apple Developer account requirements

## 🛠️ Tech Stack
| Layer | Technology |
|-------|-----------|
| Mobile | Flutter 3.22+ / Dart 3.3+ |
| VPN Protocol | WireGuard (`wireguard_flutter`) |
| State | Flutter Riverpod |
| Navigation | GoRouter |
| API | Dio |
| Storage | flutter_secure_storage + SharedPreferences |
| Backend | Node.js + Express |
| Database | MongoDB + Mongoose |
| Auth | JWT + bcrypt |

---
Built by **Srilambo** · [srilambo.vercel.app](https://srilambo.vercel.app)
