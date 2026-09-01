class User {
  final String id;
  final String email;
  final String name;
  final String plan; // 'free' | 'premium'
  final DateTime? planExpiresAt;
  final String? avatarUrl;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.plan,
    this.planExpiresAt,
    this.avatarUrl,
  });

  bool get isPremium => plan == 'premium';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      plan: json['plan'] as String? ?? 'free',
      planExpiresAt: json['planExpiresAt'] != null
          ? DateTime.tryParse(json['planExpiresAt'] as String)
          : null,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'email': email,
    'name': name,
    'plan': plan,
    'planExpiresAt': planExpiresAt?.toIso8601String(),
    'avatarUrl': avatarUrl,
  };
}

class AuthResponse {
  final String token;
  final User user;

  const AuthResponse({required this.token, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
