import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MemberCard extends StatelessWidget {
  final String matricule;
  final String nom;
  final String prenom;
  final String contact;
  final String logement;
  final String etablissement;
  final String statut;

  const MemberCard({
    super.key,
    required this.matricule,
    required this.nom,
    required this.prenom,
    required this.contact,
    required this.logement,
    required this.etablissement,
    required this.statut,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: 280,
            maxWidth: 460,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(0),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                spreadRadius: 4,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(1),
            child: Stack(
              children: [
                // Gradient Background
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white,
                          Colors.blue.shade100.withOpacity(0.5)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.only(
                      top: 0, left: 16, right: 16, bottom: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo and QR Code Column
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: _buildLogoAndQRSection(),
                      ),

                      const SizedBox(width: 20),

                      // Member Information
                      Expanded(child: _buildMemberInfoSection()),
                    ],
                  ),
                ),

                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    color: Colors.blue.shade50,
                    child: Center(
                      child: Text(
                        "Université de Fianarantso",
                        style: TextStyle(
                          color: Colors.blue.shade800,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                // Watermark/Overlay (Optional subtle design element)
                Positioned(
                  bottom: -20,
                  right: -20,
                  child: Opacity(
                    opacity: 0.1,
                    child: Icon(Icons.card_membership,
                        size: 120, color: Colors.blue.shade200),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogoAndQRSection() {
    return SizedBox(
      width: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo with Enhanced Shadow
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                "assets/images/logo.jpg",
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // QR Code with Elegant Border
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.blue.shade300, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: QrImageView(
              data: matricule,
              version: QrVersions.auto,
              size: 80.0,
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 4),
          color: Colors.blue.shade50,
          child: Center(
            child: Text(
              "Association des Etudiant 7 Vinagny",
              style: TextStyle(
                color: Colors.blue.shade800,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        // Name with Accent Border
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: Colors.blue.shade600,
                width: 4.0,
              ),
            ),
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade50.withOpacity(0.5),
                Colors.transparent
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Text(
            "$nom $prenom",
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),

        const SizedBox(height: 10),

        // Information Rows with Modern Icons
        _buildInfoRow(Icons.phone_rounded, "0$contact"),
        const SizedBox(height: 6),
        _buildInfoRow(Icons.location_city_rounded, logement),
        const SizedBox(height: 6),
        _buildInfoRow(Icons.school_rounded, etablissement),
        const SizedBox(height: 6),

        // Status and Matricule Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildInfoRow(Icons.work_rounded, statut),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.shade600,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                "N° $matricule",
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: Colors.blue.shade100.withOpacity(0.6),
          child: Icon(icon, size: 14, color: Colors.blue.shade700),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
