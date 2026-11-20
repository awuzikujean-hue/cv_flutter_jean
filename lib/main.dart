import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const CvFamilyApp());

class CvFamilyApp extends StatelessWidget {
  const CvFamilyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF0B1F3A);
    const blue = Color(0xFF1976D2);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CV de Jean Awuziku',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: blue, primary: navy),
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
        appBarTheme: const AppBarTheme(
          backgroundColor: navy,
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.blueGrey.shade100),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: blue, width: 2),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _loading = false);
    if (_username.text.trim() == 'jean' && _password.text == '123456') {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => const AppShell()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Identifiant ou mot de passe incorrect.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0B1F3A),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: const Column(
                        children: [
                          CircleAvatar(
                            radius: 38,
                            backgroundColor: Color(0xFF2C8BEA),
                            child: Icon(
                              Icons.lan,
                              color: Colors.white,
                              size: 42,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Bienvenue',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'CV & Famille de Jean Awuziku',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    TextFormField(
                      controller: _username,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Identifiant',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Saisissez votre identifiant'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _password,
                      obscureText: _obscure,
                      onFieldSubmitted: (_) => _login(),
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          tooltip: _obscure ? 'Afficher' : 'Masquer',
                          onPressed: () => setState(() => _obscure = !_obscure),
                          icon: Icon(
                            _obscure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Saisissez votre mot de passe'
                          : null,
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _loading ? null : _login,
                      icon: _loading
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.login),
                      label: Text(_loading ? 'Connexion...' : 'Se connecter'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Démo : jean / 123456',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;
  final _pages = const [
    HomeScreen(),
    CvScreen(),
    FamilyScreen(),
    ContactScreen(),
  ];
  final _titles = const ['Accueil', 'Mon CV', 'Ma famille', 'Contact'];

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_index]),
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
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.badge_outlined),
            selectedIcon: Icon(Icons.badge),
            label: 'Mon CV',
          ),
          NavigationDestination(
            icon: Icon(Icons.family_restroom_outlined),
            selectedIcon: Icon(Icons.family_restroom),
            label: 'Famille',
          ),
          NavigationDestination(
            icon: Icon(Icons.mail_outline),
            selectedIcon: Icon(Icons.mail),
            label: 'Contact',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _ProfileHeader(),
        const SizedBox(height: 20),
        const SectionTitle(
          title: 'À propos de moi',
          icon: Icons.person_outline,
        ),
        const InfoCard(
          icon: Icons.school_outlined,
          title: 'Étudiant en Informatique',
          text: 'Option Réseaux et Télécommunications • ISIG-Goma • Licence 3',
        ),
        const SizedBox(height: 12),
        const SectionTitle(title: 'Mon parcours', icon: Icons.timeline),
        const InfoCard(
          icon: Icons.work_outline,
          title: 'Expérience',
          text: 'Stage académique chez Global Technologie, maintenance informatique et configuration réseau.',
        ),
        const SizedBox(height: 12),
        const InfoCard(
          icon: Icons.code,
          title: 'Projet tutoré',
          text: 'Conception d’un portail web de gestion des appels d’offres des marchés publics, cas de la mairie de Goma.',
        ),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0B1F3A), Color(0xFF1976D2)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white24,
            backgroundImage: AssetImage(
              'assets/images/accueil.jpeg',
            ), //[cite: 1]
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'OPUA AWUZIKU Jean',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Étudiant en Informatique',
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
                Text(
                  'Réseaux & Télécommunications',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CvScreen extends StatelessWidget {
  const CvScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        SectionTitle(
          title: 'Formation académique',
          icon: Icons.school_outlined,
        ),
        InfoCard(
          icon: Icons.account_balance_outlined,
          title: 'ISIG-Goma',
          text:
              'Licence 3 — Informatique, option Réseaux et Télécommunications.',
        ),
        SizedBox(height: 20),
        SectionTitle(
          title: 'Expériences professionnelles',
          icon: Icons.work_outline,
        ),
        BulletCard(
          items: [
            'Stage académique chez Global Technologie',
            'Maintenance informatique',
            'Installation et configuration des équipements réseaux',
            'Configuration des routeurs MikroTik',
            'Installation et configuration des caméras de surveillance',
            'Installation et configuration des équipements de transmission',
          ],
        ),
        SizedBox(height: 20),
        SectionTitle(
          title: 'Compétences techniques',
          icon: Icons.build_outlined,
        ),
        ChipsCard(
          items: [
            'Flutter & Dart',
            'HTML & CSS',
            'SQL',
            'Réseaux informatiques',
            'MikroTik',
            'Maintenance informatique',
            'Télécommunications',
          ],
        ),
        SizedBox(height: 20),
        SectionTitle(
          title: 'Langues & intérêts',
          icon: Icons.interests_outlined,
        ),
        ChipsCard(
          items: [
            'Français',
            'Anglais',
            'Langues locales',
            'Nouvelles technologies',
            'Développement d’applications',
          ],
        ),
      ],
    );
  }
}

class FamilyMember {
  final String name;
  final String relation;
  final String? imagePath;

  const FamilyMember({
    required this.name,
    required this.relation,
    this.imagePath,
  });
}

class FamilyScreen extends StatelessWidget {
  const FamilyScreen({super.key});
  @override
  Widget build(BuildContext context) {
    const members = [
      FamilyMember(
        name: 'CARMEL',
        relation: 'Maman Leki',
        imagePath: 'assets/images/carmel.jpeg', //[cite: 2]
      ),
      FamilyMember(
        name: 'AMISI',
        relation: 'Oncle Paternel',
        imagePath: 'assets/images/amisi.jpeg', //[cite: 3]
      ),
      FamilyMember(name: 'Membre 3', relation: 'Lien de parenté à compléter'),
      FamilyMember(name: 'Membre 4', relation: 'Lien de parenté à compléter'),
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: .95,
      ),
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.blue.shade50,
                  backgroundImage: member.imagePath != null
                      ? AssetImage(member.imagePath!)
                      : null,
                  child: member.imagePath == null
                      ? Icon(
                          Icons.person_outline,
                          size: 38,
                          color: Colors.blue.shade700,
                        )
                      : null,
                ),
                const SizedBox(height: 12),
                Text(
                  member.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  member.relation,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});
  Future<void> _open(BuildContext context, Uri uri, String error) async {
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication) &&
        context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Restons en contact',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0B1F3A),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Utilisez les coordonnées ci-dessous pour me joindre.',
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 20),
        _ContactCard(
          icon: Icons.person_outline,
          title: 'Nom complet',
          value: 'OPUA AWUZIKU Jean',
        ),
        _ContactCard(
          icon: Icons.phone_outlined,
          title: 'Téléphone',
          value: '+243837527821',
          onTap: () => _open(
            context,
            Uri.parse('tel:+243837527821'),
            'Impossible de lancer l’appel.',
          ),
        ),
        _ContactCard(
          icon: Icons.email_outlined,
          title: 'E-mail',
          value: 'awuzikujean@gmail.com',
          onTap: () => _open(
            context,
            Uri.parse('mailto:awuzikujean@gmail.com'),
            'Impossible d’ouvrir la messagerie.',
          ),
        ),
        const _ContactCard(
          icon: Icons.location_on_outlined,
          title: 'Adresse physique',
          value: 'Mabanga Sud',
        ),
      ],
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;
  const _ContactCard({
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    margin: const EdgeInsets.only(bottom: 12),
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue.shade50,
        child: Icon(icon, color: Colors.blue.shade800),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
      trailing: onTap == null ? null : const Icon(Icons.open_in_new),
      onTap: onTap,
    ),
  );
}

class SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  const SectionTitle({super.key, required this.title, required this.icon});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        Icon(icon, color: const Color(0xFF1976D2)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0B1F3A),
          ),
        ),
      ],
    ),
  );
}

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.text,
  });
  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    child: ListTile(
      contentPadding: const EdgeInsets.all(14),
      leading: Icon(icon, color: const Color(0xFF1976D2), size: 30),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Text(text),
      ),
    ),
  );
}

class BulletCard extends StatelessWidget {
  final List<String> items;
  const BulletCard({super.key, required this.items});
  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '•  ',
                      style: TextStyle(
                        color: Color(0xFF1976D2),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(child: Text(item)),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    ),
  );
}

class ChipsCard extends StatelessWidget {
  final List<String> items;
  const ChipsCard({super.key, required this.items});
  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: items
            .map(
              (item) => Chip(
                label: Text(item),
                avatar: const Icon(Icons.check, size: 16),
              ),
            )
            .toList(),
      ),
    ),
  );
}
