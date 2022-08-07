import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/splash/splash_screen.dart';

import '../../size_config.dart';
import '../sign_in/sign_in_screen.dart';

class AnimatedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AnimatedSplashScreen(
      splash: SplashScreen(),
      nextScreen: SignInScreen(),
      duration: 2500,
      splashTransition: SplashTransition.scaleTransition,
    );
  }
}
