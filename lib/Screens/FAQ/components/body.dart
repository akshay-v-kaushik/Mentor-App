import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/Screens/FAQ/components/Faq_tile.dart';
import 'package:project/Screens/sign_in/sign_in_screen.dart';

import '../../../components/default_button.dart';
import '../../../components/firebase_verification.dart';
import '../../../size_config.dart';
import 'package:getwidget/getwidget.dart';

class Body extends StatelessWidget {
  Body({Key? key}) : super(key: key);

  List<Map<String, String>> faq_qsn = [
    {
      "Title": "Why is this app used?",
      "Desc":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
    },
    {
      "Title": "How to search for the courses?",
      "Desc":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with.",
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: SingleChildScrollView(
      child: Column(children: <Widget>[
        SizedBox(height: getProportionateScreenHeight(20)),
        Text(
          "Frequently Asked Questions",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(20),
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(50)),
        FaqTile(
          title: faq_qsn[0]["Title"],
          desc: faq_qsn[0]["Desc"],
        ),
        FaqTile(
          title: faq_qsn[1]["Title"],
          desc: faq_qsn[1]["Desc"],
        ),
        FaqTile(
          title: "TITLE",
          desc: "lorem ipsum",
        ),
        SizedBox(height: getProportionateScreenHeight(30)),
      ]),
    )));
  }
}
