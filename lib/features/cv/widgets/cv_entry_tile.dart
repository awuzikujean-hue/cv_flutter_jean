import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/bullet_list.dart';
import '../../../models/cv_entry.dart';

class CvEntryTile extends StatelessWidget {
  const CvEntryTile({super.key, required this.entry});

  final CvEntry entry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          entry.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        if (entry.subtitle != null)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              entry.subtitle!,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.blue,
              ),
            ),
          ),
        if (entry.description != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              entry.description!,
              style: const TextStyle(
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
          ),
        if (entry.bullets.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: BulletList(items: entry.bullets),
          ),
      ],
    );
  }
}
