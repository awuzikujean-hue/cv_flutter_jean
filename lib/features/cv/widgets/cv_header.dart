import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/profile_avatar.dart';
import '../../../data/profile_data.dart';

/// Bandeau supérieur du CV : photo, nom, titre.
class CvHeader extends StatelessWidget {
  const CvHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final big = constraints.maxWidth >= 680;
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: big ? 32 : 20,
            vertical: big ? 28 : 20,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.navy, Color(0xFF123A6B)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Row(
            children: [
              ProfileAvatar(size: big ? 108 : 76),
              SizedBox(width: big ? 24 : 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ProfileData.fullName,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: big ? 28 : 19,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      ProfileData.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: big ? 16 : 14,
                      ),
                    ),
                    Text(
                      ProfileData.speciality,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: big ? 14 : 12.5,
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
