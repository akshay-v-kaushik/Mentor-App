import 'package:flutter/material.dart';

import '../../Models/user.dart';
import '../../size_config.dart';
import 'components/body.dart';

class OtpScreen extends StatelessWidget {
  static String routeName = "/otp";
  var _User = UserModel();
  OtpScreen(this._User);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("OTP Verification"),
      ),
      body:  Body(_User),
    );
  }
}
