import 'package:flutter/material.dart';
import 'package:project/Screens/edit_profile/Components/body.dart';
import 'package:project/constants.dart';
import 'package:project/theme.dart';

import '../../size_config.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);
  static String routeName = "/edit_profile";

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        titleTextStyle: headingStyle,
      ),
      body: Body(),
    );
  }
}
