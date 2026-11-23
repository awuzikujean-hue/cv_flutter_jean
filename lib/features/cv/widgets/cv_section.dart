import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_colors.dart';

/// Titre de rubrique (majuscules + filet d'accent) suivi de son contenu.
class CvSection extends StatelessWidget {
  const CvSection({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: AppColors.blue,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 36,
          height: 3,
          decoration: BoxDecoration(
            color: AppColors.blue,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}
