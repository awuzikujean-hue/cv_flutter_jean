import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_colors.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          leading: CircleAvatar(
            backgroundColor: AppColors.accentSoft,
            child: Icon(icon, color: AppColors.blue),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(value),
          trailing: onTap == null ? null : const Icon(Icons.open_in_new),
          onTap: onTap,
        ),
      ),
    );
  }
}
