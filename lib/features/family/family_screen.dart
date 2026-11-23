import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/content_container.dart';
import '../../core/widgets/section_title.dart';
import '../../models/family_member.dart';
import '../../services/api_service.dart';
import 'widgets/member_form_dialog.dart';
import 'widgets/member_tile.dart';

/// Membres de la famille, lus et modifiés via l'API REST (MySQL).
/// Rien n'est conservé uniquement en mémoire : après chaque opération,
/// la liste est rechargée depuis le serveur.
class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  List<FamilyMember>? _members;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// Charge la liste depuis l'API. En mode [silent], la liste actuelle reste
  /// affichée (pas de roue de chargement) et est remplacée dès la réponse.
  Future<void> _load({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }
    try {
      final list = await ApiService.getFamilyMembers();
      if (!mounted) return;
      setState(() {
        _members = list;
        _error = null;
        _loading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        if (!silent || _members == null) _error = e.message;
      });
    }
  }

  void _snack(String message, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.redAccent : null,
      ),
    );
  }

  /// Exécute une opération API. Si elle réussit : la liste affichée est
  /// mise à jour tout de suite ([localUpdate]), puis resynchronisée avec le
  /// serveur en arrière-plan. Plus besoin d'actualiser à la main.
  Future<void> _run(
    Future<void> Function() action,
    String success, {
    void Function()? localUpdate,
  }) async {
    try {
      await action();
    } on ApiException catch (e) {
      if (!mounted) return;
      _snack(e.message, error: true);
      return;
    }
    if (!mounted) return;
    if (localUpdate != null) setState(localUpdate);
    _snack(success);
    await _load(silent: true);
  }

  Future<void> _add() async {
    final result = await showDialog<MemberFormResult>(
      context: context,
      builder: (_) => const MemberFormDialog(),
    );
    if (result == null || !mounted) return;
    await _run(
      () => ApiService.ajouterMembre(result.member, image: result.image),
      'Membre ajouté.',
    );
  }

  Future<void> _edit(FamilyMember current) async {
    final result = await showDialog<MemberFormResult>(
      context: context,
      builder: (_) => MemberFormDialog(member: current),
    );
    if (result == null || !mounted) return;
    final updated = FamilyMember(
      id: current.id,
      nom: result.member.nom,
      postnom: result.member.postnom,
      prenom: result.member.prenom,
      lieuNaissance: result.member.lieuNaissance,
      dateNaissance: result.member.dateNaissance,
      parente: result.member.parente,
      imageUrl: result.image == null ? current.imageUrl : null,
    );
    await _run(
      () => ApiService.modifierMembre(result.member, image: result.image),
      'Membre modifié.',
      localUpdate: () => _members = [
        for (final m in _members ?? const <FamilyMember>[])
          m.id == current.id ? updated : m,
      ],
    );
  }

  Future<void> _delete(FamilyMember member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Supprimer ce membre ?'),
        content: Text('${member.fullName} sera supprimé définitivement.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await _run(
      () => ApiService.supprimerMembre(member.id),
      'Membre supprimé.',
      localUpdate: () => _members = [
        for (final m in _members ?? const <FamilyMember>[])
          if (m.id != member.id) m,
      ],
    );
  }

  void _onAction(FamilyMember member, MemberAction action) {
    switch (action) {
      case MemberAction.edit:
        _edit(member);
      case MemberAction.delete:
        _delete(member);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Ajouter'),
      ),
      body: ContentContainer(
        maxWidth: 800,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    final members = _members;
    if (members == null) {
      if (_loading) return const Center(child: CircularProgressIndicator());
      return _ErrorView(
        message: _error ?? 'Une erreur est survenue.',
        onRetry: _load,
      );
    }
    return RefreshIndicator(
      onRefresh: () => _load(silent: true),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 96),
        children: [
          const SectionTitle(
            title: 'Ma famille',
            icon: Icons.family_restroom_outlined,
          ),
          if (members.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: Center(
                child: Text(
                  'Aucun membre enregistré pour le moment.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            )
          else
            for (final member in members)
              MemberTile(
                key: ValueKey(member.id),
                member: member,
                onAction: (action) => _onAction(member, action),
              ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}
