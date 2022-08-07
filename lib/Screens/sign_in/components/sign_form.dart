import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/Models/user.dart';
import 'package:project/Screens/login_success/login_success_screen.dart';
import 'package:project/components/SnackBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../components/custom_surfix_icon.dart';
import '../../../components/default_button.dart';
import '../../../components/firebase_verification.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../forgot_password/forget_password_screen.dart';
import '../../home/home_screen.dart';

class SignForm extends StatefulWidget {
  const SignForm({Key? key}) : super(key: key);

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  final _User = UserModel();
  final List<String> errors = [];
  bool passwordText = false;
  var map = {
    'email': [''],
    'password': ['']
  };
  String svgicon = "assets/icons/PasswordHidden.svg";
  String? email;
  String? password;
  bool? remember = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  void addError({String? error, String? name}) {
    if (!map[name]!.contains(error)) {
      setState(() {
        map[name]!.add(error!);
      });
    }
  }

  void removeError({String? error, String? name}) {
    if (map[name]!.contains(error)) {
      setState(() {
        map[name]!.remove(error!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            buildEmailFormField(),
            FormError(errors: map['email']!),
            SizedBox(
              height: getProportionateScreenHeight(30),
            ),
            buildPasswordFormField(),
            FormError(errors: map['password']!),
            SizedBox(
              height: getProportionateScreenHeight(30),
            ),
            Row(
              children: [
                Checkbox(
                  value: remember,
                  activeColor: kPrimaryColor,
                  onChanged: (value) {
                    setState(() {
                      remember = value;
                    });
                  },
                ),
                Text("Remember me"),
                Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(
                      context, ForgotPasswordScreen.routeName),
                  child: const Text(
                    "Forget Password",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            DefaultButton(
              text: "Login",
              press: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  String? message = await AuthenticationService(auth)
                      .signIn(email: email, password: password);
                  if (message == "Signed in") {
                    if (remember == true) {
                      final SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      sharedPreferences.setString('email', email.toString());
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                        Snackbar().snackbar("Login Successful", Colors.green));

                    Navigator.pushNamedAndRemoveUntil(context,
                        HomeScreen.routeName, ModalRoute.withName('/'));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        Snackbar().snackbar(message.toString(), Colors.red));
                  }
                }
              },
            )
          ],
        ));
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      autofocus: false,
      obscureText: passwordText ? false : true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError, name: "password");
        }
        if (passwordValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidPassError, name: "password");
        }
        if ((!(_User.confirm_password == null) &&
            _User.confirm_password == value)) {
          removeError(error: kMatchPassError, name: "password");
        }
        _User.password = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError, name: "password");
          return "";
        } else if (!passwordValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidPassError, name: "password");
          return "";
        }
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
            svgIcon: svgicon,
            tap: () {
              setState(() {
                passwordText = !passwordText;
                if (passwordText) {
                  svgicon = "assets/icons/PasswordView.svg";
                } else {
                  svgicon = "assets/icons/PasswordHidden.svg";
                }
              });
            }),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      autofocus: false,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError, name: "email");
        }
        if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError, name: "email");
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError, name: "email");
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError, name: "email");
          return "";
        }
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //not working******************
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Mail.svg",
        ),
      ),
    );
  }
}
