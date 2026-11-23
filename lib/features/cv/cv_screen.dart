import 'package:material_ui/material_ui.dart';

import '../../core/widgets/content_container.dart';
import 'cv_pdf_service.dart';
import 'widgets/cv_paper.dart';

class CvScreen extends StatelessWidget {
  const CvScreen({super.key});

  Future<void> _print(BuildContext context) async {
    try {
      await CvPdfService.printCv();
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible de générer le PDF du CV.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ContentContainer(
      maxWidth: 980,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.tonalIcon(
              onPressed: () => _print(context),
              icon: const Icon(Icons.print_outlined),
              label: const Text('Imprimer / PDF'),
            ),
          ),
          const SizedBox(height: 14),
          const CvPaper(),
        ],
      ),
    );
  }
}
