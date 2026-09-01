import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Centralized storage — secure for tokens, prefs for settings
class StorageService {
  static late SharedPreferences _prefs;
  static const _secure = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ── Auth token ─────────────────────────────────────────────
  static const _tokenKey = 'auth_token';
  static Future<void> saveToken(String token) =>
      _secure.write(key: _tokenKey, value: token);
  static Future<String?> getToken() => _secure.read(key: _tokenKey);
  static Future<void> deleteToken() => _secure.delete(key: _tokenKey);

  // ── Last selected server ───────────────────────────────────
  static const _serverKey = 'last_server_id';
  static Future<void> saveLastServerId(String id) =>
      _prefs.setString(_serverKey, id);
  static String? getLastServerId() => _prefs.getString(_serverKey);

  // ── Kill switch setting ────────────────────────────────────
  static const _killSwitchKey = 'kill_switch_enabled';
  static bool getKillSwitch() => _prefs.getBool(_killSwitchKey) ?? true;
  static Future<void> setKillSwitch(bool value) =>
      _prefs.setBool(_killSwitchKey, value);

  // ── Auto-connect setting ───────────────────────────────────
  static const _autoConnectKey = 'auto_connect_enabled';
  static bool getAutoConnect() => _prefs.getBool(_autoConnectKey) ?? false;
  static Future<void> setAutoConnect(bool value) =>
      _prefs.setBool(_autoConnectKey, value);

  // ── Onboarding seen ───────────────────────────────────────
  static const _onboardingKey = 'onboarding_done';
  static bool isOnboardingDone() => _prefs.getBool(_onboardingKey) ?? false;
  static Future<void> markOnboardingDone() =>
      _prefs.setBool(_onboardingKey, true);

  // ── Clear all (logout) ─────────────────────────────────────
  static Future<void> clear() async {
    await deleteToken();
    await _prefs.remove(_serverKey);
  }
}
