import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/family_member.dart';

enum MemberAction { edit, delete }

/// Carte d'un membre avec menu Modifier / Supprimer.
class MemberTile extends StatelessWidget {
  const MemberTile({super.key, required this.member, required this.onAction});

  final FamilyMember member;
  final ValueChanged<MemberAction> onAction;

  @override
  Widget build(BuildContext context) {
    final details = [
      if (member.parente.isNotEmpty) member.parente,
      if (member.lieuNaissance.isNotEmpty || member.dateNaissance.isNotEmpty)
        'né(e) ${member.lieuNaissance.isNotEmpty ? 'à ${member.lieuNaissance}' : ''}'
            '${member.dateNaissance.isNotEmpty ? ' le ${member.dateNaissance}' : ''}',
    ].join(' • ');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: _Avatar(member: member),
        title: Text(
          member.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(details),
        trailing: PopupMenuButton<MemberAction>(
          tooltip: 'Actions',
          onSelected: onAction,
          itemBuilder: (_) => const [
            PopupMenuItem(value: MemberAction.edit, child: Text('Modifier')),
            PopupMenuItem(value: MemberAction.delete, child: Text('Supprimer')),
          ],
        ),
      ),
    );
  }
}

/// Photo du membre (`image_url`), ou ses initiales à défaut.
class _Avatar extends StatelessWidget {
  const _Avatar({required this.member});

  final FamilyMember member;

  @override
  Widget build(BuildContext context) {
    final initials = CircleAvatar(
      radius: 28,
      backgroundColor: AppColors.accentSoft,
      foregroundColor: AppColors.blue,
      child: Text(
        member.initials,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
    final url = member.imageUrl;
    if (url == null) return initials;
    return ClipOval(
      child: SizedBox.square(
        dimension: 56,
        child: Image.network(
          url,
          fit: BoxFit.cover,
          // Sur le web, charge l'image via une balise <img> : évite le blocage CORS.
          webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
          errorBuilder: (_, error, _) {
            debugPrint('Photo non chargée ($url) : $error');
            return initials;
          },
        ),
      ),
    );
  }
}
