import 'package:flutter/material.dart';
import '../../../../Models/user.dart';
import '../../../../size_config.dart';
import 'faculty_form.dart';

class Body extends StatelessWidget {
  var User;

   Body(this.User);

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
                Text(
                  "Profile",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(30),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Complete your details",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                FacultyForm(User),
                
                SizedBox(height: getProportionateScreenHeight(20)),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
