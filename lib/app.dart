import 'package:material_ui/material_ui.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/login_screen.dart';

/// Racine de l'application : thème global + première page (connexion).
class CvFamilyApp extends StatelessWidget {
  const CvFamilyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CV de Jean Awuziku',
      theme: AppTheme.light,
      home: const LoginScreen(),
    );
  }
}
