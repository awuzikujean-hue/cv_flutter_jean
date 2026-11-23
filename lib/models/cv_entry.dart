/// Bloc générique du CV (formation, expérience, projet).
class CvEntry {
  const CvEntry({
    required this.title,
    this.subtitle,
    this.description,
    this.bullets = const [],
  });

  final String title;
  final String? subtitle;
  final String? description;
  final List<String> bullets;
}
