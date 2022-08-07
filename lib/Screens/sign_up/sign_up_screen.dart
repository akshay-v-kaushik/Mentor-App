import 'package:flutter/material.dart';
import 'package:project/constants.dart';

import '../../size_config.dart';
import 'components/body.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "/sign_up";
  
  const SignUpScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Account",        
        ),                 
      ),
      body: const Body(),
    );
  }
}
