import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

/// Ouvre un lien externe (appel, e-mail, web) et affiche un message
/// si l'ouverture est impossible.
Future<void> openExternal(
  BuildContext context,
  Uri uri,
  String errorMessage,
) async {
  var opened = false;
  try {
    opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {
    opened = false;
  }
  if (!opened && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }
}
