import 'package:material_ui/material_ui.dart';

import '../../../data/cv_data.dart';
import '../../../data/profile_data.dart';
import '../../../models/cv_entry.dart';
import 'cv_contact_row.dart';
import 'cv_entry_tile.dart';
import 'cv_header.dart';
import 'cv_section.dart';
import 'cv_tag_wrap.dart';

/// « Feuille » du CV : bandeau d'en-tête puis deux colonnes sur grand écran
/// (profil à gauche, parcours à droite), une seule colonne sur téléphone.
class CvPaper extends StatelessWidget {
  const CvPaper({super.key});

  static const double _wideBreakpoint = 680;
  static const double _sidebarWidth = 250;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140B1F3A),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            const CvHeader(),
            Padding(
              padding: const EdgeInsets.all(24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final main = _spaced(_mainSections(), 24);
                  final side = _spaced(_sidebarSections(), 24);
                  if (constraints.maxWidth >= _wideBreakpoint) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: _sidebarWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: side,
                          ),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: main,
                          ),
                        ),
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _spaced([..._mainSections(), ..._sidebarSections()], 24),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static List<Widget> _mainSections() => [
        CvSection(
          title: 'Formation académique',
          child: _entries(CvData.education),
        ),
        CvSection(
          title: 'Expérience professionnelle',
          child: _entries(CvData.experiences),
        ),
      ];

  static List<Widget> _sidebarSections() => [
        const CvSection(
          title: 'Contact',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CvContactRow(icon: Icons.phone_outlined, text: ProfileData.phone),
              CvContactRow(icon: Icons.email_outlined, text: ProfileData.email),
              CvContactRow(
                icon: Icons.location_on_outlined,
                text: ProfileData.address,
              ),
            ],
          ),
        ),
        const CvSection(
          title: 'Compétences',
          child: CvTagWrap(items: CvData.skills),
        ),
        const CvSection(
          title: 'Langues',
          child: CvTagWrap(items: CvData.languages),
        ),
        const CvSection(
          title: 'Centres d’intérêt',
          child: CvTagWrap(items: CvData.interests),
        ),
      ];

  static Widget _entries(List<CvEntry> entries) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _spaced(
        [for (final e in entries) CvEntryTile(entry: e)],
        16,
      ),
    );
  }

  static List<Widget> _spaced(List<Widget> items, double gap) => [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) SizedBox(height: gap),
          items[i],
        ],
      ];
}
