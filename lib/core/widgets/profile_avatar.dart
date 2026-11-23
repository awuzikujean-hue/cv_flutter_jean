import 'package:material_ui/material_ui.dart';

import '../constants/app_assets.dart';

/// Photo de profil ronde. Source unique : [AppAssets.profilePhoto].
/// Si l'image est introuvable, une icône de remplacement s'affiche.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    this.size = 88,
    this.borderColor = Colors.white,
    this.borderWidth = 3,
  });

  final double size;
  final Color borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white24,
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          AppAssets.profilePhoto,
          fit: BoxFit.cover,
          alignment: const Alignment(0, -0.7),
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.person, size: size * 0.55, color: Colors.white70),
        ),
      ),
    );
  }
}
