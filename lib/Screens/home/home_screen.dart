import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project/enums.dart';

import '../../components/custom_bottom_navbar.dart';
import '../../constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String routeName = "/home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          title: Text("Home"),
        ),
        bottomNavigationBar: CustomBottomNavbar(selectedMenu: MenuState.home),
      ),
    );
  }
}
