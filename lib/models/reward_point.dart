class RewardPoint {
  final String id;
  final String userId;
  final String userName;
  final int points;
  final String reason;
  final DateTime createdAt;
  final String type; // 'earned' or 'redeemed'

  RewardPoint({
    required this.id,
    required this.userId,
    required this.userName,
    required this.points,
    required this.reason,
    required this.createdAt,
    required this.type,
  });

  factory RewardPoint.fromJson(Map<String, dynamic> json) {
    return RewardPoint(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? '',
      points: json['points'] ?? 0,
      reason: json['reason'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      type: json['type'] ?? 'earned',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'points': points,
      'reason': reason,
      'created_at': createdAt.toIso8601String(),
      'type': type,
    };
  }
}
