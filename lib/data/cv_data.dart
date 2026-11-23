import '../models/cv_entry.dart';

/// Contenu du CV. Modifiez uniquement ce fichier pour mettre le CV à jour
/// (écran + export PDF).
abstract final class CvData {
  static const List<CvEntry> education = [
    CvEntry(
      title: 'ISIG-Goma',
      subtitle: 'Licence 3 — Informatique',
      description: 'Option Réseaux et Télécommunications.',
    ),
  ];

  static const List<CvEntry> experiences = [
    CvEntry(
      title: 'Stage académique',
      subtitle: 'Global Technologie',
      bullets: [
        'Maintenance informatique',
        'Installation et configuration des équipements réseaux',
        'Configuration des routeurs MikroTik',
        'Installation et configuration des caméras de surveillance',
        'Installation et configuration des équipements de transmission',
      ],
    ),
  ];

  static const List<String> skills = [
    'Flutter & Dart',
    'HTML & CSS',
    'SQL',
    'Réseaux informatiques',
    'MikroTik',
    'Maintenance informatique',
    'Télécommunications',
  ];

  static const List<String> languages = [
    'Français',
    'Anglais',
    'Langues locales',
  ];

  static const List<String> interests = [
    'Nouvelles technologies',
    'Développement d’applications',
  ];
}
