import 'package:flutter/material.dart';
import 'package:project/screens/sign_in/components/sign_form.dart';
import 'package:project/size_config.dart';

import '../../../components/no_account_text.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                Text(
                  "Welcome",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(30),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.02),
                Text(
                  "Sign in with your email and password \nor continue with social media",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                SignForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                NoAccountText()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
