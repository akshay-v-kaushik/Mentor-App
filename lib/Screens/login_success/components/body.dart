import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/Screens/sign_in/sign_in_screen.dart';

import '../../../components/default_button.dart';
import '../../../components/firebase_verification.dart';
import '../../../size_config.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.04),
          Text("Hello User"),
          // Image.asset(
          //   "assets/images/success.png",
          //   height: SizeConfig.screenHeight * 0.4,
          // ),
          SizedBox(
            height: SizeConfig.screenHeight * 0.08,
          ),
          Text(
            "Login Success",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(30),
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: SizeConfig.screenWidth * 0.6,
            child: DefaultButton(
              text: "Back to Home",
              press: () async {
                AuthenticationService(FirebaseAuth.instance).signOut();
                Navigator.popAndPushNamed(context, SignInScreen.routeName);
              },
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
