import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/launcher.dart';
import '../../core/widgets/content_container.dart';
import '../../data/profile_data.dart';
import 'widgets/contact_card.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentContainer(
      maxWidth: 720,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Restons en contact',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Utilisez les coordonnées ci-dessous pour me joindre.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          const ContactCard(
            icon: Icons.person_outline,
            title: 'Nom complet',
            value: ProfileData.fullName,
          ),
          ContactCard(
            icon: Icons.phone_outlined,
            title: 'Téléphone',
            value: ProfileData.phone,
            onTap: () => openExternal(
              context,
              Uri.parse('tel:${ProfileData.phone}'),
              'Impossible de lancer l’appel.',
            ),
          ),
          ContactCard(
            icon: Icons.email_outlined,
            title: 'E-mail',
            value: ProfileData.email,
            onTap: () => openExternal(
              context,
              Uri.parse('mailto:${ProfileData.email}'),
              'Impossible d’ouvrir la messagerie.',
            ),
          ),
          const ContactCard(
            icon: Icons.location_on_outlined,
            title: 'Adresse physique',
            value: ProfileData.address,
          ),
        ],
      ),
    );
  }
}
