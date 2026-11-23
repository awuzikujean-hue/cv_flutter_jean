import 'package:flutter/foundation.dart';

/// Adresse de l'API REST (projet PHP « api-test » servi par XAMPP).
///
/// - Windows / Web / iOS simulateur : `http://localhost/api-test/public`
/// - Émulateur Android : `10.0.2.2` désigne le PC hôte.
/// - Téléphone physique : utilisez l'IP locale du PC (ex. 192.168.1.20) :
///   `flutter run --dart-define=API_BASE_URL=http://192.168.1.20/api-test/public`
///   (et autorisez Apache dans le pare-feu Windows).
abstract final class ApiConfig {
  static const String _override = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    if (_override.isNotEmpty) return _override;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2/api-test/public';
    }
    return 'http://localhost/api-test/public';
  }

  /// Les `image_url` renvoyées par l'API contiennent `localhost`, qui ne
  /// fonctionne pas sur émulateur/téléphone : on reprend l'hôte de [baseUrl].
  static String resolveUrl(String url) {
    final u = Uri.tryParse(url);
    final base = Uri.parse(baseUrl);
    if (u == null) return url;
    // Chemin relatif (ex. « uploads/famille/x.png ») : on le rattache à l'API.
    if (!u.hasAuthority) {
      return '$baseUrl/${url.startsWith('/') ? url.substring(1) : url}';
    }
    return Uri(
      scheme: base.scheme,
      host: base.host,
      port: base.hasPort ? base.port : null,
      path: u.path,
      query: u.hasQuery ? u.query : null,
    ).toString();
  }
}
