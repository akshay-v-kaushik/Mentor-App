import 'package:flutter/material.dart';
import 'package:project/Screens/edit_profile/Components/basic_form.dart';
import 'package:project/Screens/edit_profile/Components/edit_faculty.dart';
import 'package:project/Screens/edit_profile/Components/edit_parent.dart';

import '../../../components/default_button.dart';
import '../../../size_config.dart';

class Body extends StatelessWidget {
  Body({Key? key}) : super(key: key);
  String type = "Parent";
  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return SafeArea(
        child: PageView(
      controller: controller,
      children: <Widget>[
        Container(
          child: Column(
            children: [
              BasicForm(),
              SizedBox(height: getProportionateScreenHeight(40)),
              DefaultButton(
                  text: "Next",
                  press: () => {
                        controller.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease)
                      }),
            ],
          ),
          padding: EdgeInsets.all(30.0),
        ),
        Container(
          child: type == "Faculty" ? Faculty() : Parent(),
          padding: EdgeInsets.all(30.0),
        )
      ],
    ));
  }
}
