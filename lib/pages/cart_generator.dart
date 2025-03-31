import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_desktop_app/pages/cart/member_cart.dart';
import 'package:my_desktop_app/services/connection_db.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class CartGenerator extends StatefulWidget {
  const CartGenerator({
    super.key,
  });

  @override
  State<CartGenerator> createState() => _CartGeneratorState();
}

class _CartGeneratorState extends State<CartGenerator> {
  final TextEditingController _matriculeController = TextEditingController();
  final ScreenshotController _screenshotController = ScreenshotController();
  Map<String, String>? membreData;
  bool isLoading = false;

  Future<void> _rechercheMembre(String matricule) async {
    if (matricule.isEmpty) {
      _showSnackBar('Veuillez entrer un numéro de matricule', Colors.orange);
      return;
    }

    setState(() => isLoading = true);

    try {
      final data = await ApiService().getData(matricule);
      setState(() {
        membreData = {
          'numero_matricule': data.numero_matricule,
          'nom': data.nom,
          'prenom': data.prenom,
          'contact': data.contact,
          'logement': data.logement,
          'etablissement': data.etablissement,
          'statut': data.status,
        };
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      String errorMessage = e.toString().contains('Étudiant non trouvé')
          ? 'Aucun étudiant trouvé avec ce matricule'
          : 'Erreur de recherche';
      _showSnackBar(errorMessage, Colors.red);
    }
  }

  Future<void> _capturerEtSauvegarderCarte() async {
    try {
      // Capturer l'image
      final Uint8List? image = await _screenshotController.capture();
      if (image != null) {
        if (kIsWeb) {
          // Pour le web : déclencher un téléchargement
          _saveImageOnWeb(image);
        } else {
          // Pour desktop : sauvegarder dans le dossier Téléchargements
          await _saveImageOnDesktop(image);
        }
      } else {
        _showSnackBar('Échec de la capture de l\'image', Colors.red);
      }
    } catch (e) {
      _showSnackBar('Erreur lors de la sauvegarde: $e', Colors.red);
    }
  }

  void _saveImageOnWeb(Uint8List image) {
    // Créer un nom de fichier
    final fileName =
        'carte_membre_${membreData!['numero_matricule']}_${DateTime.now().millisecondsSinceEpoch}.png';

    // Convertir l'image en base64 et créer un lien de téléchargement
    final base64Image = base64Encode(image);
    // final anchor =
    //     html.AnchorElement(href: 'data:image/png;base64,$base64Image')
    //       ..setAttribute('download', fileName)
    //       ..click();

    _showSnackBar('Téléchargement démarré: $fileName', Colors.green);
  }

  Future<void> _saveImageOnDesktop(Uint8List image) async {
    // Obtenir le dossier de téléchargements
    final directory = await getDownloadsDirectory();
    if (directory != null) {
      // Créer un nom de fichier unique
      final fileName =
          'carte_membre_${membreData!['numero_matricule']}_${DateTime.now().millisecondsSinceEpoch}.png';
      final filePath = '${directory.path}${Platform.pathSeparator}$fileName';

      // Sauvegarder l'image
      final file = File(filePath);
      await file.writeAsBytes(image);

      debugPrint("filePath: $filePath");

      _showSnackBar('Carte sauvegardée avec succès: $filePath', Colors.green);
    } else {
      _showSnackBar(
          'Impossible d\'accéder au dossier de téléchargements', Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
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
            "Creation de carte membre",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 460,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: _matriculeController,
                    decoration: InputDecoration(
                      hintText: 'Entrez le matricule du membre',
                      prefixIcon: Icon(Icons.search, color: Colors.blue[800]),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: isLoading
                          ? const CircularProgressIndicator()
                          : IconButton(
                              icon: Icon(Icons.send, color: Colors.blue[800]),
                              onPressed: () =>
                                  _rechercheMembre(_matriculeController.text),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Screenshot(
                  controller: _screenshotController,
                  child: MemberCard(
                    matricule: membreData?['numero_matricule'] ?? '',
                    nom: membreData?['nom'] ?? '',
                    prenom: membreData?['prenom'] ?? '',
                    contact: membreData?['contact'] ?? '',
                    logement: membreData?['logement'] ?? '',
                    etablissement: membreData?['etablissement'] ?? '',
                    statut: membreData?['statut'] ?? '',
                  ),
                ),
                const SizedBox(height: 24),
                _buildActionButton(
                  icon: Icons.save_alt,
                  label: 'Capturer et Sauvegarder',
                  color: Colors.blue,
                  onPressed:
                      membreData != null ? _capturerEtSauvegarderCarte : null,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _matriculeController.dispose();
    super.dispose();
  }
}
