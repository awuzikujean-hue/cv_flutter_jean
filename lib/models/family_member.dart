import '../core/config/api_config.dart';

/// Un membre de famille tel que stocké dans MySQL (table `famille_membre`).
class FamilyMember {
  const FamilyMember({
    required this.id,
    required this.nom,
    required this.postnom,
    required this.prenom,
    required this.lieuNaissance,
    required this.dateNaissance,
    required this.parente,
    this.imageUrl,
  });

  /// Identifiant fourni par l'API : indispensable pour modifier/supprimer.
  final String id;
  final String nom;
  final String postnom;
  final String prenom;
  final String lieuNaissance;

  /// Format AAAA-MM-JJ.
  final String dateNaissance;
  final String parente;

  /// Adresse complète de la photo (`image_url` de l'API), ou null.
  final String? imageUrl;

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'] ?? json['id_famille_membre'] ?? json['id_membre'];
    if (rawId == null) {
      throw const FormatException('Membre sans identifiant dans la réponse.');
    }
    String text(String key) => json[key]?.toString() ?? '';
    final date = text('date_naissance');
    // `image_url` si présent, sinon le chemin relatif `image` (uploads/famille/...).
    final rawImage = (json['image_url'] ?? json['image'])?.toString() ?? '';
    return FamilyMember(
      id: rawId.toString(),
      nom: text('nom'),
      postnom: text('postnom'),
      prenom: text('prenom'),
      lieuNaissance: text('lieu_naissance'),
      dateNaissance: date.length >= 10 ? date.substring(0, 10) : date,
      parente: text('parente'),
      imageUrl: rawImage.isEmpty ? null : ApiConfig.resolveUrl(rawImage),
    );
  }

  /// Corps JSON envoyé à l'API (sans l'id, qui est dans l'URL).
  Map<String, String> toJson() => {
        'nom': nom,
        'postnom': postnom,
        'prenom': prenom,
        'lieu_naissance': lieuNaissance,
        'date_naissance': dateNaissance,
        'parente': parente,
      };

  String get fullName => [prenom, nom, postnom]
      .where((part) => part.trim().isNotEmpty)
      .join(' ');

  String get initials {
    final p = prenom.trim();
    final n = nom.trim();
    final text = '${p.isEmpty ? '' : p[0]}${n.isEmpty ? '' : n[0]}';
    return text.isEmpty ? '?' : text.toUpperCase();
  }
}
