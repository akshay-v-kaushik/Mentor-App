import 'package:flutter/material.dart';
import 'package:project/Screens/AdditionalForms/ParentForm/components/parent_form.dart';
import 'package:project/size_config.dart';

class Body extends StatelessWidget {
  var _User;

  Body(this._User);

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
                SizedBox(height: SizeConfig.screenHeight * 0.02), // 4%
                const Text(
                  "Complete your details",
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.5,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                ParentForm(_User),
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
