import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project/constants.dart';

import '../../components/custom_bottom_navbar.dart';
import '../../enums.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({Key? key}) : super(key: key);
  static String routeName = "/course";

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Course"),
        ),
        bottomNavigationBar: CustomBottomNavbar(selectedMenu: MenuState.course),
      ),
    );
  }
}
