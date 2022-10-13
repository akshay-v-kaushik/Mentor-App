import 'package:flutter/material.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';
import 'package:project/constants.dart';

import '../../../size_config.dart';

class FaqTile extends StatelessWidget {
  const FaqTile({
    Key? key,
    this.title,
    this.desc,
  }) : super(key: key);
  final String? title, desc;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GFAccordion(
        collapsedIcon: Icon(Icons.add),
        expandedIcon: Icon(Icons.minimize),
        title: title,
        content: desc,
      ),
      SizedBox(height: getProportionateScreenHeight(10)),
    ]);
  }
}
