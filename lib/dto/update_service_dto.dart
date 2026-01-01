class UpdateServiceDto {
  final String id;
  final String name;
  final String description;
  final int duration;
  final int price;
  final int isActive;
  final String image;
  final int points;

  UpdateServiceDto({
    required this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.price,
    required this.isActive,
    required this.image,
    required this.points,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'duration': duration,
      'price': price,
      'is_active': isActive,
      'image': image,
      'points': points,
    };
  }
}
