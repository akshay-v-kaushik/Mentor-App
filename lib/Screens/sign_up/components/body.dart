import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'sign_up_form.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.02), 
                 Text("Register Account", style: headingStyle, textAlign : TextAlign.center),
                const Text(
                  "Complete your details",
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.5,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                const SignUpForm(),
                // SizedBox(height: SizeConfig.screenHeight * 0.08),
                SizedBox(height: getProportionateScreenHeight(20)),
                // Text(
                //   'By continuing, you confirm that you agree \nwith our Terms and Conditions',
                //   textAlign: TextAlign.center,
                //   style: Theme.of(context).textTheme.caption,
                //   textScaleFactor: 1.2,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
