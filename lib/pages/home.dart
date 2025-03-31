import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:my_desktop_app/components/displaying_side_menu.dart';
import 'package:my_desktop_app/components/side_menu.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();

  @override
  void initState() {
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenuContents(sideMenu: sideMenu),

          // Displaying content
          Expanded(
            child: DisplyingSideMenu(
              pageController: pageController,
              sideMenuController: sideMenu,
            ),
          )
        ],
      ),
    );
  }
}
