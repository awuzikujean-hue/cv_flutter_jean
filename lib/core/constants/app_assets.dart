/// Chemins des images de l'application.
///
/// Pour REMPLACER une photo : gardez le même nom de fichier dans
/// `assets/images/...` (ou changez le chemin ci-dessous).
/// Les membres de famille viennent maintenant de l'API (voir `lib/services`).
abstract final class AppAssets {
  /// Photo affichée à côté du nom (accueil, CV).
  static const String profilePhoto = 'assets/images/profile/accueil.jpg';

  static const String _familyDir = 'assets/images/family';
  static const String family1 = '$_familyDir/famille_1.jpg';
  static const String family2 = '$_familyDir/famille_2.jpg';
  static const String family3 = '$_familyDir/famille_3.jpg';
  static const String family4 = '$_familyDir/famille_4.jpg';
}
