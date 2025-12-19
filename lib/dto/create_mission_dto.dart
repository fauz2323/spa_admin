class CreateMissionDto {
  final String title;
  final String description;
  final int points;
  final int goal;
  final String? id;

  CreateMissionDto({
    required this.title,
    required this.description,
    required this.points,
    required this.goal,
    this.id,
  });
}
