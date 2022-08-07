import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project/Screens/login_success/login_success_screen.dart';
import 'package:project/Screens/profile/components/profile_menu.dart';
import 'package:project/Screens/profile/components/profile_pic.dart';
import 'package:project/Screens/sign_in/sign_in_screen.dart';
import 'package:project/constants.dart';

import '../../../components/SnackBar.dart';
import '../../../components/firebase_verification.dart';
import '../../../size_config.dart';
import '../../edit_profile/edit_profile_screen.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfilePic(),
        SizedBox(height: getProportionateScreenHeight(80)),
        ProfileMenu(
          text: "My Account",
          icon: "assets/icons/User Icon.svg",
          press: () {
            Navigator.pushNamed(context, EditProfileScreen.routeName);
          },
        ),
        SizedBox(height: 10),
        ProfileMenu(
          text: "Help Center",
          icon: "assets/icons/Question mark.svg",
          press: () {},
        ),
        SizedBox(height: 10),
        ProfileMenu(
          text: "Logout",
          icon: "assets/icons/Log out.svg",
          press: () async {
            AuthenticationService(FirebaseAuth.instance).signOut();
            Navigator.popAndPushNamed(context, SignInScreen.routeName);
            ScaffoldMessenger.of(context).showSnackBar(
                Snackbar().snackbar("Logout Successful", Colors.green));
          },
        ),
      ],
    );
  }
}
