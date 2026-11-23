import 'package:material_ui/material_ui.dart';

import '../auth/login_screen.dart';
import '../contact/contact_screen.dart';
import '../cv/cv_screen.dart';
import '../family/family_screen.dart';
import '../home/home_screen.dart';

class _Destination {
  const _Destination({
    required this.label,
    required this.title,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final String title;
  final IconData icon;
  final IconData selectedIcon;
}

/// Coque principale : barre du haut + navigation.
/// Navigation par la barre du bas, comme dans la version d'origine.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const _pages = [
    HomeScreen(),
    CvScreen(),
    FamilyScreen(),
    ContactScreen(),
  ];

  static const _destinations = [
    _Destination(
      label: 'Accueil',
      title: 'Accueil',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
    ),
    _Destination(
      label: 'Mon CV',
      title: 'Mon CV',
      icon: Icons.badge_outlined,
      selectedIcon: Icons.badge,
    ),
    _Destination(
      label: 'Famille',
      title: 'Ma famille',
      icon: Icons.family_restroom_outlined,
      selectedIcon: Icons.family_restroom,
    ),
    _Destination(
      label: 'Contact',
      title: 'Contact',
      icon: Icons.mail_outline,
      selectedIcon: Icons.mail,
    ),
  ];

  void _select(int value) => setState(() => _index = value);

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_destinations[_index].title),
        actions: [
          IconButton(
            tooltip: 'Se déconnecter',
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _select,
        destinations: [
          for (final d in _destinations)
            NavigationDestination(
              icon: Icon(d.icon),
              selectedIcon: Icon(d.selectedIcon),
              label: d.label,
            ),
        ],
      ),
    );
  }
}
