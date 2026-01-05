class CreateMissionDto {
  final String title;
  final String description;
  final int points;
  final int goal;
  final String? id;
  final String? expiredDate;
  final String? serviceList;
  final Function()? backCallback;

  CreateMissionDto({
    required this.title,
    required this.description,
    required this.points,
    required this.goal,
    this.expiredDate,
    this.serviceList,
    this.id,
    this.backCallback,
  });
}
