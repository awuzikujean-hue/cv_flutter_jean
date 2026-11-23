import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../core/config/api_config.dart';
import '../models/family_member.dart';
import '../models/picked_image.dart';

/// Erreur affichable à l'utilisateur (message déjà en français).
class ApiException implements Exception {
  const ApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Tous les appels réseau vers l'API REST sont centralisés ici,
/// pour ne pas mélanger requêtes HTTP et interface.
abstract final class ApiService {
  static const Duration _timeout = Duration(seconds: 10);
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Uri _uri(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  /// Envoie la requête, décode le JSON et vérifie le code HTTP
  /// ainsi que le champ `success` renvoyé par l'API.
  static Future<Map<String, dynamic>> _send(
    Future<http.Response> Function() request,
  ) async {
    final http.Response response;
    try {
      response = await request().timeout(_timeout);
    } on TimeoutException {
      throw const ApiException(
        'Le serveur ne répond pas. Vérifiez qu’Apache et MySQL sont démarrés.',
      );
    } catch (_) {
      throw const ApiException(
        'Impossible de joindre le serveur. Vérifiez XAMPP et l’adresse de l’API.',
      );
    }

    Object? body;
    try {
      body = jsonDecode(utf8.decode(response.bodyBytes));
    } catch (_) {
      throw ApiException(
        'Réponse invalide du serveur (code ${response.statusCode}).',
      );
    }
    if (body is! Map<String, dynamic>) {
      throw ApiException(
        'Réponse inattendue du serveur (code ${response.statusCode}).',
      );
    }

    final httpOk = response.statusCode >= 200 && response.statusCode < 300;
    if (!httpOk || body['success'] != true) {
      final message = body['message'] ?? body['error'];
      final errors = body['errors'];
      final details = errors is Map
          ? errors.values.map((e) => e.toString()).join(' • ')
          : '';
      final base = message is String && message.isNotEmpty
          ? message
          : 'Erreur ${response.statusCode} renvoyée par le serveur.';
      final full = details.isEmpty ? base : '$base : $details';
      throw ApiException('$full (code ${response.statusCode})');
    }
    return body;
  }

  /// Teste l'accès à la route de liste.
  static Future<void> testerConnexion() async {
    await _send(() => http.get(_uri('/famille-membres'), headers: _headers));
  }

  /// Vérifie les identifiants auprès de l'API. Lève une [ApiException]
  /// (avec le message du serveur) si la connexion est refusée.
  static Future<void> seConnecter(String email, String password) async {
    await _send(
      () => http.post(
        _uri('/accounts/login'),
        headers: _headers,
        body: jsonEncode({'email': email.trim(), 'password': password}),
      ),
    );
  }

  /// Crée un compte (mot de passe : 6 caractères minimum, règle de l'API).
  static Future<void> sInscrire(String email, String password) async {
    await _send(
      () => http.post(
        _uri('/accounts/register'),
        headers: _headers,
        body: jsonEncode({'email': email.trim(), 'password': password}),
      ),
    );
  }

  static Future<List<FamilyMember>> getFamilyMembers() async {
    final body = await _send(
      () => http.get(_uri('/famille-membres'), headers: _headers),
    );
    final data = body['data'];
    if (data is! List) {
      throw const ApiException('Format de liste inattendu.');
    }
    try {
      return [
        for (final item in data)
          FamilyMember.fromJson(Map<String, dynamic>.from(item as Map)),
      ];
    } on FormatException catch (e) {
      throw ApiException(e.message);
    }
  }

  /// Envoi en multipart/form-data (nécessaire pour transmettre une photo).
  static Future<http.Response> _multipart(
    String path,
    FamilyMember member,
    PickedImage? image,
  ) async {
    final request = http.MultipartRequest('POST', _uri(path))
      ..headers['Accept'] = 'application/json'
      ..fields.addAll(member.toJson());
    if (image != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          image.bytes,
          filename: image.name,
          contentType: _mediaType(image.name),
        ),
      );
    }
    final streamed = await request.send();
    return await http.Response.fromStream(streamed);
  }

  static MediaType _mediaType(String name) {
    final ext = name.toLowerCase().split('.').last;
    return switch (ext) {
      'png' => MediaType('image', 'png'),
      'gif' => MediaType('image', 'gif'),
      'webp' => MediaType('image', 'webp'),
      _ => MediaType('image', 'jpeg'),
    };
  }

  /// Ajout : JSON sans photo, multipart avec photo.
  static Future<void> ajouterMembre(
    FamilyMember member, {
    PickedImage? image,
  }) async {
    await _send(
      () => image == null
          ? http.post(
              _uri('/famille-membres'),
              headers: _headers,
              body: jsonEncode(member.toJson()),
            )
          : _multipart('/famille-membres', member, image),
    );
  }

  /// Modification. Avec une nouvelle photo : `POST` multipart sur
  /// `/famille-membres/{id}`. Sans photo : `PUT` JSON (photo conservée) ;
  /// si le serveur le refuse, on retente avec le `POST` form-data, aussi
  /// documenté par l'API (certains serveurs gèrent mal `PUT`).
  static Future<void> modifierMembre(
    FamilyMember member, {
    PickedImage? image,
  }) async {
    final path = '/famille-membres/${member.id}';
    if (image != null) {
      await _send(() => _multipart(path, member, image));
      return;
    }
    try {
      await _send(
        () => http.put(
          _uri(path),
          headers: _headers,
          body: jsonEncode(member.toJson()),
        ),
      );
    } on ApiException catch (firstError) {
      try {
        await _send(() => _multipart(path, member, null));
      } on ApiException {
        throw firstError;
      }
    }
  }

  static Future<void> supprimerMembre(String id) async {
    await _send(
      () => http.delete(_uri('/famille-membres/$id'), headers: _headers),
    );
  }
}
