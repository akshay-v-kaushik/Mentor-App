import 'package:flutter/widgets.dart';
import 'package:project/Screens/edit_profile/edit_profile_screen.dart';
import 'package:project/Screens/home/home_screen.dart';
import 'Screens/AdditionalForms/FacultyForm/faculty_screen.dart';
import 'Screens/FAQ/faq_screen.dart';
import 'Screens/course/course_screen.dart';
import 'Screens/forgot_password/forget_password_screen.dart';
import 'Screens/login_success/login_success_screen.dart';
import 'Screens/profile/profile_screen.dart';
import 'Screens/sign_in/sign_in_screen.dart';
import 'Screens/splash/splash_screen.dart';
import 'screens/sign_up/sign_up_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  ProfileScreen.routeName: (context) => const ProfileScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  CourseScreen.routeName: (context) => const CourseScreen(),
  EditProfileScreen.routeName: (context) => const EditProfileScreen(),
  FaqScreen.routeName: (context) => const FaqScreen()
};  // FacultyScreen.routeName: (context) => const FacultyScreen(),

