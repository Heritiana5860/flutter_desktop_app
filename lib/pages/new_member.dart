import 'package:flutter/material.dart';
import 'package:my_desktop_app/components/dropdown.dart';
import 'package:my_desktop_app/components/my_textfield.dart';
import 'package:my_desktop_app/data/etablissement.dart';
import 'package:my_desktop_app/data/niveau.dart';
import 'package:my_desktop_app/models/data_models.dart';
import 'package:my_desktop_app/services/connection_db.dart';

class NewMember extends StatefulWidget {
  const NewMember({super.key, this.studentToEdit, this.onEditSuccess});

  final DataModels? studentToEdit;
  final VoidCallback? onEditSuccess;

  @override
  State<NewMember> createState() => _NewMemberState();
}

class _NewMemberState extends State<NewMember> {
  final _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  bool _isEditing = false;

  late TextEditingController numeroMatriculeController;
  late TextEditingController nomController;
  late TextEditingController prenomController;
  late TextEditingController contactController;
  late TextEditingController logementController;
  late TextEditingController promotionController;

  late String _selectedEtablissement;
  late String _selectedNiveau;
  late String _selectedStatut;

  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    // N'oubliez pas de libérer les FocusNode
    numeroMatriculeController.dispose();
    nomController.dispose();
    prenomController.dispose();
    contactController.dispose();
    logementController.dispose();
    promotionController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _isEditing = widget.studentToEdit != null;
    numeroMatriculeController = TextEditingController(
        text: widget.studentToEdit?.numero_matricule ?? '');
    nomController =
        TextEditingController(text: widget.studentToEdit?.nom ?? '');
    prenomController =
        TextEditingController(text: widget.studentToEdit?.prenom ?? '');
    contactController =
        TextEditingController(text: widget.studentToEdit?.contact ?? '');
    logementController =
        TextEditingController(text: widget.studentToEdit?.logement ?? '');
    promotionController =
        TextEditingController(text: widget.studentToEdit?.promotion ?? '');

    _selectedEtablissement =
        widget.studentToEdit?.etablissement ?? eteblissement[0];
    _selectedNiveau = widget.studentToEdit?.niveau ?? 'Licence 1';
    _selectedStatut = widget.studentToEdit?.status.trim() ?? statut[0];

    // Vérifier si l'établissement est dans la liste, sinon utiliser la valeur par défaut
    final etablissementValue = widget.studentToEdit?.etablissement;
    _selectedEtablissement =
        etablissementValue != null && eteblissement.contains(etablissementValue)
            ? etablissementValue
            : eteblissement[0];

    // Vérifier si le niveau est dans la liste, sinon utiliser la valeur par défaut
    final niveauValue = widget.studentToEdit?.niveau;
    _selectedNiveau = niveauValue != null && niveau.contains(niveauValue)
        ? niveauValue
        : niveau[0];

    // Vérifier si le statut est dans la liste, sinon utiliser la valeur par défaut
    final statutValue = widget.studentToEdit?.status.trim();
    _selectedStatut = statutValue != null && statut.contains(statutValue)
        ? statutValue
        : statut[0];
  }

  void saveData() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isProcessing = true);

      try {
        // Créer une instance du modèle DataModels avec les valeurs du formulaire
        final dataToSave = DataModels(
            numero_matricule: numeroMatriculeController.text,
            nom: nomController.text,
            prenom: prenomController.text,
            contact: contactController.text,
            logement: logementController.text,
            promotion: promotionController.text,
            etablissement: _selectedEtablissement,
            niveau: _selectedNiveau,
            status: _selectedStatut);

        // Utiliser le service API pour insérer les données
        final apiService = ApiService();
        if (_isEditing) {
          await apiService.updateData(dataToSave);

          // Appeler le callback onEditSuccess pour informer le parent
          if (widget.onEditSuccess != null) {
            widget.onEditSuccess!();
          }
        } else {
          await apiService.insertData(dataToSave);
          reset();
        }

        if (mounted) {
          // Afficher un message de succès
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_isEditing
                  ? 'Étudiant modifié avec succès'
                  : 'Étudiant enregistré avec succès'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        // Gérer les exceptions
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur lors de l\'enregistrement: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        // Arrêter l'indicateur de chargement
        if (mounted) {
          setState(() => _isProcessing = false);
        }
      }
    }
  }

  void reset() {
    // Réinitialiser le formulaire
    _formKey.currentState!.reset();
    numeroMatriculeController.clear();
    nomController.clear();
    prenomController.clear();
    contactController.clear();
    logementController.clear();
    promotionController.clear();
    setState(() {
      _selectedEtablissement = eteblissement[0];
      _selectedNiveau = niveau[0];
      _selectedStatut = statut[0];
    });
    _isEditing = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Text(
            "Insertion de nouveau membre",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Card(
                  margin: const EdgeInsets.all(24),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Informations de l'étudiant",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Grid layout pour les champs
                          GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            childAspectRatio: 4,
                            crossAxisSpacing: 24,
                            mainAxisSpacing: 8,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              MyTextfield(
                                hintText: "Numero Matricule",
                                prefixIcon: Icons.badge_outlined,
                                controller: numeroMatriculeController,
                              ),
                              MyTextfield(
                                hintText: "Nom",
                                prefixIcon: Icons.person_outline,
                                controller: nomController,
                              ),
                              MyTextfield(
                                hintText: "Prenom",
                                prefixIcon: Icons.person_outline,
                                controller: prenomController,
                              ),
                              MyTextfield(
                                hintText: "Contact",
                                prefixIcon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                                controller: contactController,
                              ),
                              MyTextfield(
                                hintText: "Logement",
                                prefixIcon: Icons.home_outlined,
                                controller: logementController,
                              ),
                              MyTextfield(
                                hintText: "Promotion",
                                prefixIcon: Icons.date_range_outlined,
                                controller: promotionController,
                              ),
                              CustomDropdown(
                                label: "Etablissement",
                                options: eteblissement,
                                initialValue: _selectedEtablissement,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedEtablissement = value;
                                  });
                                },
                              ),
                              CustomDropdown(
                                label: "Niveau",
                                options: niveau,
                                initialValue: _selectedNiveau,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedNiveau = value;
                                  });
                                },
                              ),
                              CustomDropdown(
                                label: "Statut",
                                options: statut,
                                initialValue: _selectedStatut,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedStatut = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton(
                                onPressed: () => reset(),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text("Annuler"),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton(
                                onPressed: _isProcessing ? null : saveData,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2E86DE),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: _isProcessing
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : Text(
                                        _isEditing ? "Modifier" : "Enregistrer",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
