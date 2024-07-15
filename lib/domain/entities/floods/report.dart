class Report {
  final int id, userId;
  final String location, description, latitude, longitude, image;
  final DateTime createdAt;

  Report({
    required this.id,
    required this.userId,
    required this.location,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.image,
    required this.createdAt
  });
}