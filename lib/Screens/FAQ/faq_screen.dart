import 'package:flutter/material.dart';
import 'package:project/screens/FAQ/components/body.dart';

import '../../size_config.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({Key? key}) : super(key: key);
  static String routeName = "/faq";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("FAQ"),
      ),
      body: Body(),
    );
  }
}
