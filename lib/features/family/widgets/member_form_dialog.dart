import 'package:file_picker/file_picker.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/family_member.dart';
import '../../../models/picked_image.dart';

/// Résultat du formulaire : le membre saisi + une nouvelle photo éventuelle.
class MemberFormResult {
  const MemberFormResult(this.member, this.image);
  final FamilyMember member;
  final PickedImage? image;
}

/// Formulaire d'ajout / de modification d'un membre.
/// Retourne un [MemberFormResult] (avec l'id existant en modification),
/// ou `null` si l'utilisateur annule. L'appel API est fait par l'écran.
class MemberFormDialog extends StatefulWidget {
  const MemberFormDialog({super.key, this.member});

  final FamilyMember? member;

  @override
  State<MemberFormDialog> createState() => _MemberFormDialogState();
}

class _MemberFormDialogState extends State<MemberFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _nom = TextEditingController(text: widget.member?.nom);
  late final _postnom = TextEditingController(text: widget.member?.postnom);
  late final _prenom = TextEditingController(text: widget.member?.prenom);
  late final _lieu = TextEditingController(text: widget.member?.lieuNaissance);
  late final _date = TextEditingController(text: widget.member?.dateNaissance);
  late final _parente = TextEditingController(text: widget.member?.parente);

  static const int _maxImageBytes = 2 * 1024 * 1024; // limite de l'API : 2 Mo

  PickedImage? _image;
  String? _imageError;

  bool get _editing => widget.member != null;

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    final bytes = file.bytes;
    if (!mounted || bytes == null) return;
    if (bytes.length > _maxImageBytes) {
      setState(() => _imageError = 'Image trop lourde (2 Mo maximum).');
      return;
    }
    setState(() {
      _imageError = null;
      _image = PickedImage(bytes: bytes, name: file.name);
    });
  }

  @override
  void dispose() {
    for (final c in [_nom, _postnom, _prenom, _lieu, _date, _parente]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'Champ obligatoire' : null;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = DateTime.tryParse(_date.text) ?? DateTime(now.year - 20);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isAfter(now) ? now : initial,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked == null) return;
    final mm = picked.month.toString().padLeft(2, '0');
    final dd = picked.day.toString().padLeft(2, '0');
    _date.text = '${picked.year}-$mm-$dd';
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      MemberFormResult(
        FamilyMember(
          id: widget.member?.id ?? '',
          nom: _nom.text.trim(),
          postnom: _postnom.text.trim(),
          prenom: _prenom.text.trim(),
          lieuNaissance: _lieu.text.trim(),
          dateNaissance: _date.text.trim(),
          parente: _parente.text.trim(),
        ),
        _image,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_editing ? 'Modifier le membre' : 'Ajouter un membre'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _photoPicker(),
                _field(_nom, 'Nom'),
                _field(_postnom, 'Postnom'),
                _field(_prenom, 'Prénom'),
                _field(_lieu, 'Lieu de naissance'),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: TextFormField(
                    controller: _date,
                    readOnly: true,
                    onTap: _pickDate,
                    decoration: const InputDecoration(
                      labelText: 'Date de naissance (AAAA-MM-JJ)',
                      suffixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    validator: _required,
                  ),
                ),
                _field(_parente, 'Parenté (ex. Frère, Mère)'),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(_editing ? 'Enregistrer' : 'Ajouter'),
        ),
      ],
    );
  }

  Widget _photoPicker() {
    final Widget preview;
    if (_image != null) {
      preview = Image.memory(_image!.bytes, fit: BoxFit.cover);
    } else if (widget.member?.imageUrl != null) {
      preview = Image.network(
        widget.member!.imageUrl!,
        fit: BoxFit.cover,
        webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
        errorBuilder: (_, _, _) => const Icon(Icons.person_outline),
      );
    } else {
      preview = const Icon(Icons.person_outline, color: AppColors.blue);
    }
    final hasPhoto = _image != null || widget.member?.imageUrl != null;
    return Column(
      children: [
        Row(
          children: [
            ClipOval(
              child: SizedBox.square(
                dimension: 64,
                child: ColoredBox(color: AppColors.accentSoft, child: preview),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo_library_outlined),
                label: Text(
                  hasPhoto ? 'Changer la photo' : 'Ajouter une photo',
                ),
              ),
            ),
          ],
        ),
        if (_imageError != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              _imageError!,
              style: const TextStyle(color: Colors.redAccent, fontSize: 12.5),
            ),
          ),
      ],
    );
  }

  Widget _field(TextEditingController controller, String label) => Padding(
    padding: const EdgeInsets.only(top: 12),
    child: TextFormField(
      controller: controller,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(labelText: label),
      validator: _required,
    ),
  );
}
