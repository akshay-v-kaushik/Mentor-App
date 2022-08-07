import 'package:flutter/material.dart';
import 'package:project/constants.dart';
import 'package:project/screens/sign_in/sign_in_screen.dart';
import 'package:project/screens/splash/components/splash_content.dart';

import '../../../components/default_button.dart';
import '../../../size_config.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "Welcome to Marg Dharshak!",
      "image": "assets/images/splash1.png"
    },
    {
      "text":
          "We help people conect with expert advisors \nall around India",
      "image": "assets/images/splash3.png"
    },
    {
      "text": "We help pave way for prosperous careers for students. \nAll at your fingertips!",
      "image": "assets/images/splash2.png"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            SizedBox(height: getProportionateScreenHeight(50),),
            Text(
          "MARGDHARSHAK",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(30),
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
            Expanded(
              flex: 3,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: splashData.length,
                itemBuilder: (context, index) => SplashContent(
                  image: splashData[index]["image"],
                  text: splashData[index]['text'],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20),
                ),
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          splashData.length, (index) => buildDot(index: index)),
                    ),
                    Spacer(flex: 3),
                    SizedBox(
                      width: double.infinity,
                      height: getProportionateScreenHeight(56),
                      child: DefaultButton(
                        text: "Continue",
                        press: () {
                          Navigator.pushNamed(context, SignInScreen.routeName);
                        },
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
