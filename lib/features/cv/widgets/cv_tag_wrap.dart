import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_colors.dart';

/// Étiquettes arrondies (compétences, langues, intérêts).
class CvTagWrap extends StatelessWidget {
  const CvTagWrap({super.key, required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final item in items)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accentSoft,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
            ),
          ),
      ],
    );
  }
}
