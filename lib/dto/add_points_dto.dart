class AddPointsDto {
  final String email;
  final int points;
  final String description;

  const AddPointsDto({
    required this.email,
    required this.points,
    required this.description,
  });
}
