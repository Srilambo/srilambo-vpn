import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:srilambo_vpn/models/user.dart';
import 'package:srilambo_vpn/models/vpn_server.dart';
import 'package:srilambo_vpn/services/storage_service.dart';

class ApiService {
  // Change this to your deployed backend URL
  static const String _baseUrl = 'http://10.0.2.2:5000/api'; // localhost for Android emulator

  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add auth token interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await StorageService.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          StorageService.deleteToken();
        }
        return handler.next(error);
      },
    ));

    // Pretty logging in debug mode
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: false,
      requestBody: true,
      responseBody: true,
    ));
  }

  // ── Auth ───────────────────────────────────────────────────────────────────
  Future<AuthResponse> login(String email, String password) async {
    final response = await _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    return AuthResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AuthResponse> register(String name, String email, String password) async {
    final response = await _dio.post('/auth/register', data: {
      'name': name,
      'email': email,
      'password': password,
    });
    return AuthResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<User> getProfile() async {
    final response = await _dio.get('/auth/me');
    return User.fromJson(response.data['user'] as Map<String, dynamic>);
  }

  // ── VPN Servers ────────────────────────────────────────────────────────────
  Future<List<VpnServer>> getServers() async {
    final response = await _dio.get('/servers');
    final data = response.data['servers'] as List<dynamic>;
    return data.map((e) => VpnServer.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Get a WireGuard config for a specific server (requires auth)
  Future<String> getWireGuardConfig(String serverId) async {
    final response = await _dio.get('/servers/$serverId/config');
    return response.data['config'] as String;
  }

  // ── Stats ─────────────────────────────────────────────────────────────────
  Future<void> reportSession({
    required String serverId,
    required int durationSeconds,
    required int bytesTransferred,
  }) async {
    await _dio.post('/sessions', data: {
      'serverId': serverId,
      'duration': durationSeconds,
      'bytesTransferred': bytesTransferred,
    });
  }
}
