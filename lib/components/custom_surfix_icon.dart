// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../size_config.dart';

class CustomSuffixIcon extends StatelessWidget {
  const CustomSuffixIcon({Key? key, required this.svgIcon, this.tap})
      : super(key: key);
  final Function? tap;
  final String svgIcon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        0,
        getProportionateScreenWidth(20),
        getProportionateScreenWidth(20),
        getProportionateScreenWidth(20),
      ),
      child: GestureDetector(
        onTap: tap as void Function()?,
        child: SvgPicture.asset(
          svgIcon,
          height: getProportionateScreenWidth(18),
        ),
      ),
    );
  }
}
