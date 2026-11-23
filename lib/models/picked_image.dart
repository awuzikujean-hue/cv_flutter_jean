import 'dart:typed_data';

/// Photo choisie par l'utilisateur, en attente d'envoi à l'API.
class PickedImage {
  const PickedImage({required this.bytes, required this.name});

  final Uint8List bytes;
  final String name;
}
