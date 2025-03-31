import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';

class SideMenuContents extends StatelessWidget {
  const SideMenuContents({
    super.key,
    required this.sideMenu,
  });

  final SideMenuController sideMenu;

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      controller: sideMenu,
      style: SideMenuStyle(
        // showTooltip: false,
        displayMode: MediaQuery.of(context).size.width > 1000
            ? SideMenuDisplayMode.open
            : SideMenuDisplayMode.compact,
        showHamburger: true,
        hoverColor: Colors.blue[100],
        selectedHoverColor: Colors.blue[100],
        selectedColor: Colors.lightBlue,
        selectedTitleTextStyle: const TextStyle(color: Colors.white),
        selectedIconColor: Colors.white,
        backgroundColor: Colors.white,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
        ),
      ),
      title: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 150,
              maxWidth: 150,
            ),
            child: Image.asset(
              'assets/images/logo.jpg',
            ),
          ),
          const Divider(
            indent: 8.0,
            endIndent: 8.0,
          ),
        ],
      ),
      footer: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          child: SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Confirmation"),
                    content: Text("Voulez-vous vraiment vous déconnecter?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Annuler"),
                      ),
                      TextButton(
                        onPressed: () {
                          // Code de déconnexion
                          Navigator.pop(context);
                        },
                        child: Text("Confirmer"),
                      ),
                    ],
                  ),
                );
              },
              child: Row(
                children: [
                  Icon(Icons.logout_rounded, color: Colors.grey[800]),
                  SizedBox(width: 20.0),
                  Text(
                    "Log out",
                    style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      items: [
        SideMenuItem(
          title: "Dashboard",
          icon: const Icon(Icons.dashboard),
          onTap: (index, _) {
            sideMenu.changePage(index);
          },
        ),
        SideMenuItem(
          title: "New Member",
          icon: const Icon(Icons.add_box_rounded),
          onTap: (index, _) {
            sideMenu.changePage(index);
          },
        ),
        SideMenuItem(
          title: "List of Members",
          icon: const Icon(Icons.list_alt_rounded),
          onTap: (index, _) {
            sideMenu.changePage(index);
          },
        ),
        SideMenuItem(
          title: "Cart generator",
          icon: const Icon(Icons.card_membership),
          onTap: (index, _) {
            sideMenu.changePage(index);
          },
        ),
      ],
    );
  }
}
