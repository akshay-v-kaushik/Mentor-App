import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/Models/user.dart';
import 'package:project/Screens/AdditionalForms/FacultyForm/faculty_screen.dart';
import 'package:project/Screens/login_success/login_success_screen.dart';
import 'package:project/Screens/otp/otp_screen.dart';
import 'package:project/Screens/profile/profile_screen.dart';
import 'package:project/Screens/sign_in/sign_in_screen.dart';
import 'package:project/routes.dart';
import 'package:project/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/AdditionalForms/ParentForm/parent_screen.dart';
import 'Screens/AdditionalForms/StudentForm/components/student_personal_form.dart';
import 'Screens/FAQ/faq_screen.dart';
import 'Screens/home/home_screen.dart';
import 'Screens/sign_up/sign_up_screen.dart';
import 'Screens/splash/splash_screen.dart';
import 'components/firebase_verification.dart';
import 'firebase_options.dart';

int? onBoardCounter;
String? finalEmail;
bool rememberLogin = false;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences preferences = await SharedPreferences.getInstance();
  onBoardCounter = await preferences.getInt('OnboardCounter');
  await preferences.setInt('OnboardCounter', 1);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  MyApp({Key? key}) : super(key: key) {
    getValidationData().whenComplete(() async {
      rememberLogin = finalEmail != null ? true : false;
    });
  }

  Future getValidationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    finalEmail = sharedPreferences.getString('email');
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
          initialData: null,
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: theme(),
        initialRoute: onBoardCounter == 0 || onBoardCounter == null
            ? SplashScreen.routeName
            : (rememberLogin ? HomeScreen.routeName : SignInScreen.routeName),
        routes: routes,
        // home: const FaqScreen(),
      ),
    );
  }
}
