class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final DateTime createdAt;
  final int rewardPoints;
  final bool isActive;
  final String profileImage;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.createdAt,
    required this.rewardPoints,
    required this.isActive,
    required this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      rewardPoints: json['reward_points'] ?? 0,
      isActive: json['is_active'] ?? false,
      profileImage: json['profile_image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'created_at': createdAt.toIso8601String(),
      'reward_points': rewardPoints,
      'is_active': isActive,
      'profile_image': profileImage,
    };
  }
}
