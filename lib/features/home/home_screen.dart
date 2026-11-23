import 'package:material_ui/material_ui.dart';

import '../../core/widgets/content_container.dart';
import '../../core/widgets/info_card.dart';
import '../../core/widgets/section_title.dart';
import '../../data/profile_data.dart';
import 'widgets/profile_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentContainer(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const ProfileHeader(),
          const SizedBox(height: 24),
          const SectionTitle(
            title: 'À propos de moi',
            icon: Icons.person_outline,
          ),
          const InfoCard(
            icon: Icons.school_outlined,
            title: ProfileData.title,
            text: ProfileData.aboutText,
          ),
          const SizedBox(height: 24),
          const SectionTitle(title: 'Mon parcours', icon: Icons.timeline),
          const InfoCard(
            icon: Icons.work_outline,
            title: 'Expérience',
            text: ProfileData.experienceSummary,
          ),
        ],
      ),
    );
  }
}
