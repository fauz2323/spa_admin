class CreateServiceDto {
  final String name;
  final String description;
  final int duration;
  final int price;
  final int isActive;
  final String image;
  final int point;

  CreateServiceDto({
    required this.name,
    required this.description,
    required this.duration,
    required this.price,
    required this.isActive,
    required this.image,
    required this.point,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'duration': duration,
      'price': price,
      'is_active': isActive,
      'image': image,
      'point': point,
    };
  }
}
