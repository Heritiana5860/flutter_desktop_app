import 'dart:io';
import 'dart:typed_data';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/foundation.dart';
import 'package:my_desktop_app/components/data_table.dart';
import 'package:my_desktop_app/pages/new_member.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:my_desktop_app/models/data_models.dart';
import 'package:my_desktop_app/services/connection_db.dart';

class ListOfMembers extends StatefulWidget {
  final SideMenuController sideMenuController;
  final Function(DataModels) onEditMember;
  const ListOfMembers(
      {super.key,
      required this.sideMenuController,
      required this.onEditMember});

  @override
  State<ListOfMembers> createState() => _ListOfMembersState();
}

class _ListOfMembersState extends State<ListOfMembers> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = "";
  late Future<Map<String, dynamic>> futureData;
  final ApiService _apiService = ApiService();
  int totalMembers = 0;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      futureData = _apiService.getAllData();
    });
  }

  Future<void> _editMember(DataModels member) async {
    widget.onEditMember(member);
    widget.sideMenuController.changePage(1);
  }

  Future<String> getTemporaryPath() async {
    final tempDir = Directory.systemTemp;
    return tempDir.path;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Header(
          label: "Liste des membres",
          buildExportButton: _buildExportButton(),
        ),
        const SizedBox(height: 24),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 48),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
                _isSearching = value.isNotEmpty;
              });
            },
            decoration: InputDecoration(
              hintText: 'Rechercher un membre...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _isSearching
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = "";
                          _isSearching = false;
                        });
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: DataTableWidget(
              futureFilteredMembers: getFilteredMembers(),
              apiService: _apiService,
              onDeleteSuccess: _refreshData,
              onEditRequest: _editMember,
            ),
          ),
        )
      ],
    );
  }

  Future<List<DataModels>> getFilteredMembers() async {
    final data = await futureData;
    final List<DataModels> membersList = data["etudiants"];
    totalMembers = data['total'];

    if (_searchQuery.isEmpty) return membersList;
    return membersList.where((member) {
      return member.nom.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          member.prenom.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          member.contact.contains(_searchQuery) ||
          member.logement.toLowerCase().contains(_searchQuery) ||
          member.promotion.contains(_searchQuery) ||
          member.etablissement.toLowerCase().contains(_searchQuery) ||
          member.niveau.toLowerCase().contains(_searchQuery) ||
          member.status.toLowerCase().contains(_searchQuery) ||
          member.numero_matricule.contains(_searchQuery);
    }).toList();
  }

  Future<void> _exportToPDF(BuildContext context,
      {bool filteredOnly = false}) async {
    try {
      // Indicateur de chargement
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Récupération des données
      List<DataModels> members = filteredOnly
          ? await getFilteredMembers()
          : (await futureData)["etudiants"];

      // Création du document PDF
      final pdf = pw.Document(compress: true);

      // Styles
      final headerStyle = pw.TextStyle(
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.black,
      );

      final cellStyle = pw.TextStyle(
        fontSize: 8,
        color: PdfColors.black,
      );

      final headers = [
        'N° Matricule',
        'Nom',
        'Prénom',
        'Contact',
        'Établissement',
        'Niveau',
        'Promotion',
        'Logement',
        'Statut'
      ];

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4.landscape,
          margin: const pw.EdgeInsets.all(32),
          // L'en-tête n'apparaît qu'une fois sur la première page
          header: (context) {
            if (context.pageNumber == 1) {
              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 20),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Association des Etudiants 7 Vinagny',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue800,
                      ),
                    ),
                    pw.Text(
                      'Liste des Membres',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue800,
                      ),
                    ),
                    pw.Text(
                      'Total: ${members.length} membres',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                    pw.Text(
                      'Fait le: ${DateTime.now().toString().split('.')[0]}',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Divider(),
                  ],
                ),
              );
            }
            return pw.Container();
          },
          footer: (context) => pw.Container(
            alignment: pw.Alignment.center,
            margin: const pw.EdgeInsets.only(top: 10),
            child: pw.Text(
              'Page ${context.pageNumber} / ${context.pagesCount}',
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
          build: (context) => [
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              columnWidths: {
                0: const pw.FlexColumnWidth(1.5),
                1: const pw.FlexColumnWidth(1.2),
                2: const pw.FlexColumnWidth(1.2),
                3: const pw.FlexColumnWidth(1.5),
                4: const pw.FlexColumnWidth(1),
                5: const pw.FlexColumnWidth(1),
                6: const pw.FlexColumnWidth(1.2),
                7: const pw.FlexColumnWidth(1.2),
                8: const pw.FlexColumnWidth(1),
              },
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  children: headers
                      .map((header) => pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(header, style: headerStyle),
                          ))
                      .toList(),
                ),
                ...members.map((member) => pw.TableRow(
                      children: [
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(member.numero_matricule,
                                style: cellStyle)),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(member.nom, style: cellStyle)),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(member.prenom, style: cellStyle)),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(member.contact, style: cellStyle)),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(member.etablissement,
                                style: cellStyle)),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(member.niveau, style: cellStyle)),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(member.promotion, style: cellStyle)),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(member.logement, style: cellStyle)),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(member.status, style: cellStyle)),
                      ],
                    )),
              ],
            ),
          ],
        ),
      );

      // Génération du fichier PDF
      final Uint8List pdfBytes = await pdf.save();
      final timestamp =
          DateTime.now().toString().replaceAll(RegExp(r'[^0-9]'), '');
      final filename = filteredOnly
          ? 'membres_filtres_$timestamp.pdf'
          : 'tous_les_membres_$timestamp.pdf';

      // Pour les plateformes desktop uniquement
      String? filePath;
      try {
        // Déterminer le chemin du bureau selon le système d'exploitation
        final String? desktopPath;
        if (Platform.isWindows) {
          desktopPath = '${Platform.environment['USERPROFILE']}\\Desktop';
        } else if (Platform.isMacOS || Platform.isLinux) {
          desktopPath = '${Platform.environment['HOME']}/Desktop';
        } else {
          // Cas improbable pour une application desktop, mais par sécurité
          desktopPath = null;
        }

        // Vérifier si le chemin du bureau existe
        if (desktopPath != null) {
          final directory = Directory(desktopPath);
          if (await directory.exists()) {
            filePath = '$desktopPath${Platform.pathSeparator}$filename';
          }
        }

        // Si le bureau n'est pas accessible, utiliser le répertoire temporaire
        if (filePath == null) {
          final tempDir = Directory.systemTemp;
          filePath = '${tempDir.path}${Platform.pathSeparator}$filename';
        }

        // Écrire le fichier
        final file = File(filePath);
        await file.writeAsBytes(pdfBytes);

        if (!context.mounted) return;
        Navigator.pop(context); // Fermer l'indicateur de chargement

        // Afficher une boîte de dialogue confirmant l'enregistrement
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Succès'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Fichier enregistré à:'),
                Text(filePath!, style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 10),
                Text('Total: ${members.length} membres'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fermer'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    await OpenFile.open(filePath!);
                  } catch (e) {
                    debugPrint('Erreur ouverture fichier: $e');
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Impossible d\'ouvrir le fichier: $e')),
                      );
                    }
                  }
                },
                child: const Text('Ouvrir'),
              ),
            ],
          ),
        );
      } catch (e) {
        debugPrint('Erreur écriture fichier: $e');
        if (!context.mounted) return;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur d\'écriture du fichier: $e')),
        );
      }
    } catch (e) {
      debugPrint('Erreur export PDF: $e');
      if (!context.mounted) return;
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la génération du PDF: $e')),
      );
    }
  }

  PopupMenuButton<String> _buildExportButton() {
    return PopupMenuButton<String>(
      color: Colors.white,
      onSelected: (value) {
        switch (value) {
          case 'pdf_all':
            _exportToPDF(context, filteredOnly: false);
            break;
          case 'pdf_filtered':
            _exportToPDF(context, filteredOnly: true);
            break;
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.blue[600],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: const [
            Icon(Icons.download, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Exporter',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'pdf_all',
          child: Row(
            children: [
              Icon(Icons.picture_as_pdf),
              SizedBox(width: 8),
              Text(
                'Exporter tout en PDF',
                style: TextStyle(fontSize: 13.0),
              ),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'pdf_filtered',
          child: Row(
            children: [
              Icon(Icons.filter_alt),
              SizedBox(width: 8),
              Text(
                'Exporter les résultats filtrés en PDF',
                style: TextStyle(fontSize: 13.0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key, required this.label, this.buildExportButton});

  final String label;
  final PopupMenuButton<String>? buildExportButton;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          buildExportButton!,
        ],
      ),
    );
  }
}
