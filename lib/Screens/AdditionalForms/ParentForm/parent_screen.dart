import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/Screens/AdditionalForms/ParentForm/components/body.dart';
import 'package:project/Screens/sign_in/sign_in_screen.dart';
import 'package:project/Screens/sign_up/sign_up_screen.dart';
import 'package:project/constants.dart';
import 'package:project/size_config.dart';

import '../../../components/SnackBar.dart';

class ParentFormScreen extends StatefulWidget {
  var _User;
  ParentFormScreen(this._User);

  static String routeName = "/parent_form";

  @override
  State<ParentFormScreen> createState() => _ParentFormScreenState(_User);
}

class _ParentFormScreenState extends State<ParentFormScreen> {
  var _User;

  _ParentFormScreenState(this._User);

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to cancel the registration?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'No',
                  style: TextStyle(color: kPrimaryColor),
                ),
              ),
              TextButton(
                onPressed: () async {
                  // exit(0);
                  await FirebaseAuth.instance.currentUser?.delete();
                  ScaffoldMessenger.of(context).showSnackBar(Snackbar()
                      .snackbar("Registration Cancelled", Colors.red));
                  Navigator.pushNamedAndRemoveUntil(
                      context,
                      SignUpScreen.routeName,
                      ModalRoute.withName(SignInScreen.routeName));
                },
                child:
                    const Text('Yes', style: TextStyle(color: kPrimaryColor)),
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
          title: const Text(
            "Additional Details",
            textAlign: TextAlign.center,
          ),
          titleTextStyle: headingStyle,
        ),
        body: Body(_User),
      ),
    );
  }
}
