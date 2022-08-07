import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project/Screens/profile/components/body.dart';

import '../../components/custom_bottom_navbar.dart';
import '../../constants.dart';
import '../../enums.dart';
import '../../size_config.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = "/profile";

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("PROFILE"),
        ),
        body: Body(),
        bottomNavigationBar:
            CustomBottomNavbar(selectedMenu: MenuState.profile),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'No',
                  style: TextStyle(color: kPrimaryColor),
                ),
              ),
              TextButton(
                onPressed: () => exit(0),
                child:
                    const Text('Yes', style: TextStyle(color: kPrimaryColor)),
              ),
            ],
          ),
        )) ??
        false;
  }
}
