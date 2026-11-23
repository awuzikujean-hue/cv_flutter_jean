import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/profile_avatar.dart';
import '../../../data/profile_data.dart';

/// Bandeau d'accueil : photo à côté du nom.
/// La photo se remplace via `AppAssets.profilePhoto`.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final big = constraints.maxWidth >= 600;
        return Container(
          padding: EdgeInsets.all(big ? 28 : 18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.navy, AppColors.blue],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Color(0x330B1F3A),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              ProfileAvatar(size: big ? 124 : 84),
              SizedBox(width: big ? 28 : 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ProfileData.fullName,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: big ? 28 : 20,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      ProfileData.title,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: big ? 17 : 15,
                      ),
                    ),
                    Text(
                      ProfileData.speciality,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: big ? 15 : 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
