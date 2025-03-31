import 'package:flutter/material.dart';

class Parametre extends StatelessWidget {
  const Parametre({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Paramètres",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: [
                const _SettingsCategory(title: "Général"),
                _SettingsItem(
                  icon: Icons.language,
                  title: "Langue",
                  subtitle: "Français",
                  onTap: () {},
                ),
                _SettingsItem(
                  icon: Icons.color_lens,
                  title: "Thème",
                  subtitle: "Clair",
                  onTap: () {},
                ),
                const _SettingsCategory(title: "Notifications"),
                _SettingsItem(
                  icon: Icons.notifications,
                  title: "Notifications push",
                  subtitle: "Activées",
                  trailing: Switch(value: true, onChanged: (value) {}),
                  onTap: () {},
                ),
                _SettingsItem(
                  icon: Icons.email,
                  title: "Notifications par email",
                  subtitle: "Désactivées",
                  trailing: Switch(value: false, onChanged: (value) {}),
                  onTap: () {},
                ),
                const _SettingsCategory(title: "Sécurité"),
                _SettingsItem(
                  icon: Icons.lock,
                  title: "Changer le mot de passe",
                  subtitle: "Dernière modification il y a 30 jours",
                  onTap: () {},
                ),
                _SettingsItem(
                  icon: Icons.security,
                  title: "Authentification à deux facteurs",
                  subtitle: "Désactivée",
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsCategory extends StatelessWidget {
  final String title;

  const _SettingsCategory({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.teal.shade700,
        ),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
