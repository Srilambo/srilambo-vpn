# Srilambo VPN — iOS Setup Notes

## Required iOS Capabilities (Xcode)

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select the **Runner** target → **Signing & Capabilities**
3. Click **+** and add:
   - **Network Extensions** → check "Packet Tunnel"
   - **Personal VPN**
4. Create a second **WireGuard Network Extension** target:
   - File → New → Target → Network Extension
   - Bundle ID: `com.srilambo.vpn.wireguard`
   - This is what `providerBundleIdentifier` in the app code points to

## Info.plist Additions
Add to `ios/Runner/Info.plist`:
```xml
<key>NSVPNUsageDescription</key>
<string>Srilambo VPN uses a VPN tunnel to protect your internet connection.</string>
```

## App Groups
Both the main app and the WireGuard extension must share an App Group:
- `group.com.srilambo.vpn`

Enable this in both targets' Signing & Capabilities.

## WireGuard Extension
The `wireguard_flutter` plugin will handle most of this.
See: https://pub.dev/packages/wireguard_flutter#ios-setup

## Provisioning
- You need an Apple Developer account ($99/year)
- Create App IDs for both:
  - `com.srilambo.vpn` (main app)  
  - `com.srilambo.vpn.wireguard` (network extension)
- Enable "Network Extensions" capability in each App ID
- Create provisioning profiles for both

## Testing on Real Device
iOS VPN apps CANNOT be tested on Simulator — use a real iPhone/iPad.
