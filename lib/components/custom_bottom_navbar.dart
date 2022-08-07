import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../Screens/course/course_screen.dart';
import '../Screens/home/home_screen.dart';
import '../Screens/profile/profile_screen.dart';
import '../constants.dart';
import '../enums.dart';

class CustomBottomNavbar extends StatelessWidget {
  const CustomBottomNavbar({
    Key? key,
    required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    final Color inactiveColor = Color(0xffb6b6b6);
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xffdadada).withOpacity(0.15),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: SvgPicture.asset("assets/icons/Home.svg",
                  color: MenuState.home == selectedMenu
                      ? kPrimaryColor
                      : inactiveColor),
              onPressed: (MenuState.home == selectedMenu)
                  ? () {}
                  : () {
                      Navigator.popAndPushNamed(context, HomeScreen.routeName);
                    },
            ),
            IconButton(
              icon: SvgPicture.asset("assets/icons/Book.svg",
                  color: MenuState.course == selectedMenu
                      ? kPrimaryColor
                      : inactiveColor),
              onPressed: (MenuState.course == selectedMenu)
                  ? () {}
                  : () {
                      Navigator.popAndPushNamed(
                          context, CourseScreen.routeName);
                    },
            ),
            IconButton(
              icon: SvgPicture.asset("assets/icons/User Icon.svg",
                  color: MenuState.profile == selectedMenu
                      ? kPrimaryColor
                      : inactiveColor),
              onPressed: (MenuState.profile == selectedMenu)
                  ? () {}
                  : () {
                      Navigator.popAndPushNamed(
                          context, ProfileScreen.routeName);
                    },
            ),
          ],
        ),
      ),
    );
  }
}
