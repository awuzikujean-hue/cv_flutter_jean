import 'package:flutter_test/flutter_test.dart';

import 'package:cv_flutter_jean/app.dart';
import 'package:cv_flutter_jean/models/family_member.dart';

void main() {
  testWidgets('affiche la page de connexion', (tester) async {
    await tester.pumpWidget(const CvFamilyApp());
    expect(find.text('Bienvenue'), findsOneWidget);
    expect(find.text('Se connecter'), findsOneWidget);
  });

  test('FamilyMember.fromJson lit les champs de l\'API', () {
    final member = FamilyMember.fromJson({
      'id': 7,
      'nom': 'Awuziku',
      'postnom': 'Kasereka',
      'prenom': 'Jean',
      'lieu_naissance': 'Goma',
      'date_naissance': '2000-05-12 00:00:00',
      'parente': 'Frère',
      'image_url': 'http://localhost/api-test/public/uploads/famille/a.png',
    });
    expect(member.id, '7');
    expect(member.dateNaissance, '2000-05-12');
    expect(member.imageUrl, endsWith('/uploads/famille/a.png'));
    expect(member.toJson()['lieu_naissance'], 'Goma');
  });
}
