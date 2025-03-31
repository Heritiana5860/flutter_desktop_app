import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: const Text(
            "Tableau de bord",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildDashboardCard(
                  "Utilisateurs",
                  "1,254",
                  Icons.people,
                  Colors.blue,
                ),
                _buildDashboardCard(
                  "Revenus",
                  "€8,540",
                  Icons.euro,
                  Colors.green,
                ),
                _buildDashboardCard(
                  "Produits",
                  "254",
                  Icons.shopping_cart,
                  Colors.orange,
                ),
                _buildDashboardCard(
                  "Commandes",
                  "854",
                  Icons.shopping_bag,
                  Colors.purple,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildDashboardCard(
    String title, String value, IconData icon, Color color) {
  return Card(
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
              Icon(
                icon,
                color: color,
                size: 32,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Augmentation de 15%",
            style: TextStyle(
              fontSize: 14,
              color: Colors.green.shade700,
            ),
          ),
        ],
      ),
    ),
  );
}
