import 'package:flutter/material.dart';
import 'package:project/screens/sign_in/components/body.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../size_config.dart';



class SignInScreen extends StatelessWidget {
  String? finalEmail;
  static String routeName = "/sign_in";

 
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
      ),
      body: Body(),
    );
  }
}
