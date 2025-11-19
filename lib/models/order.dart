enum OrderStatus { pending, booked, inProgress, completed, cancelled }

class Order {
  final String id;
  final String userId;
  final String userName;
  final String userPhone;
  final String serviceName;
  final DateTime bookingDate;
  final DateTime createdAt;
  final OrderStatus status;
  final double totalAmount;
  final String notes;
  final List<String> services;

  Order({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.serviceName,
    required this.bookingDate,
    required this.createdAt,
    required this.status,
    required this.totalAmount,
    required this.notes,
    required this.services,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? '',
      userPhone: json['user_phone'] ?? '',
      serviceName: json['service_name'] ?? '',
      bookingDate:
          DateTime.tryParse(json['booking_date'] ?? '') ?? DateTime.now(),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString().split('.').last == (json['status'] ?? 'pending'),
        orElse: () => OrderStatus.pending,
      ),
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      notes: json['notes'] ?? '',
      services: List<String>.from(json['services'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'user_phone': userPhone,
      'service_name': serviceName,
      'booking_date': bookingDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'status': status.toString().split('.').last,
      'total_amount': totalAmount,
      'notes': notes,
      'services': services,
    };
  }

  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.booked:
        return 'Booked';
      case OrderStatus.inProgress:
        return 'In Progress';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}
