import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/Screens/AdditionalForms/StudentForm/components/body.dart';
import 'package:project/Screens/sign_in/sign_in_screen.dart';
import 'package:project/Screens/sign_up/sign_up_screen.dart';
import 'package:project/components/SnackBar.dart';
import 'package:project/constants.dart';

import '../../../size_config.dart';

class StudentScreen extends StatefulWidget {
  var User;
  static String routeName = "/StudentForm";
  StudentScreen(this.User);

  @override
  State<StudentScreen> createState() => _StudentScreenState(User);
}

class _StudentScreenState extends State<StudentScreen> {
  var User;

  _StudentScreenState(this.User);
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
          title: const Text("Profile",
          style: TextStyle(color: Colors.black, fontFamily: "Muli"),textScaleFactor: 1.2,),
        ),
        body: Body(User),
      ),
    );
  }
}
