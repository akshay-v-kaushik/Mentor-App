import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project/constants.dart';
import 'package:project/size_config.dart';
import 'components/body.dart';

class LoginSuccessScreen extends StatefulWidget {
  const LoginSuccessScreen({Key? key}) : super(key: key);
  static String routeName = "/login_sucess";

  @override
  State<LoginSuccessScreen> createState() => _LoginSuccessScreenState();
}

class _LoginSuccessScreenState extends State<LoginSuccessScreen> {
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) =>  AlertDialog(
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
                child: const Text('Yes', style: TextStyle(color: kPrimaryColor)),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Login Success"),
        ),
        body: Body(),
      ),
    );
  }
}
