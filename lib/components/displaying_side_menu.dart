import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:my_desktop_app/models/data_models.dart';
import 'package:my_desktop_app/pages/cart_generator.dart';
import 'package:my_desktop_app/pages/dashboard.dart';
import 'package:my_desktop_app/pages/list_of_members.dart';
import 'package:my_desktop_app/pages/new_member.dart';

class DisplyingSideMenu extends StatefulWidget {
  const DisplyingSideMenu({
    super.key,
    required this.pageController,
    required this.sideMenuController,
  });

  final PageController pageController;
  final SideMenuController sideMenuController;

  @override
  State<DisplyingSideMenu> createState() => _DisplyingSideMenuState();
}

class _DisplyingSideMenuState extends State<DisplyingSideMenu> {
  DataModels? memberToEdit;
  bool editSuccess = false;

  @override
  void initState() {
    super.initState();
    // Écouter les changements de page du SideMenuController
    widget.sideMenuController.addListener(_onPageChange);
  }

  void _onPageChange(int index) {
    // Synchroniser le PageController avec le SideMenuController
    if (widget.pageController.page?.round() != index) {
      widget.pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void handleEditMember(DataModels member) {
    setState(() {
      memberToEdit = member;
      editSuccess = false;
    });
    // Naviguer vers la page NewMember (index 1)
    widget.sideMenuController.changePage(1);
  }

  void handleEditSuccess() {
    setState(() {
      editSuccess = true;
      memberToEdit = null; // Réinitialiser après l'édition
    });

    // Retourner à la liste des membres (index 2)
    widget.sideMenuController.changePage(2);

    // Afficher une notification de succès
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Étudiant modifié avec succès'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: widget.pageController,
      physics: NeverScrollableScrollPhysics(),
      onPageChanged: (index) {
        // Synchroniser le SideMenuController avec le PageController
        if (widget.sideMenuController.currentPage != index) {
          widget.sideMenuController.changePage(index);
        }
      },
      children: [
        Dashboard(),
        NewMember(
          studentToEdit: memberToEdit,
          onEditSuccess: handleEditSuccess,
        ),
        ListOfMembers(
          sideMenuController: widget.sideMenuController,
          onEditMember: handleEditMember,
        ),
        CartGenerator(),
      ],
    );
  }
}
