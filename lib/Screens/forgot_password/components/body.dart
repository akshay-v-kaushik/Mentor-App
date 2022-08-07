
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/components/default_button.dart';
import 'package:project/components/no_account_text.dart';
import 'package:project/size_config.dart';

import '../../../components/DialogBox.dart';
import '../../../components/SnackBar.dart';
import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
          ),
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.screenHeight * 0.1,
              ),
              Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(28),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Please enter your email and we will send \nyou a link to return to your account",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: SizeConfig.screenHeight * 0.1,
              ),
              ForgotPassForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPassForm extends StatefulWidget {
  const ForgotPassForm({Key? key}) : super(key: key);

  @override
  State<ForgotPassForm> createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  String? email;
  var map = {
    'email' : ['']
  };

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
            TextFormField(
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
              decoration: const InputDecoration(
                labelText: "Email",
                hintText: "Enter your email",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                suffixIcon: CustomSuffixIcon(
                  svgIcon: "assets/icons/Mail.svg",
                ),
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(30),
            ),
            FormError(errors: map['email']!),
            SizedBox(
              height: SizeConfig.screenHeight * 0.1,
            ),
            DefaultButton(
              text: "Continue",
              press: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  resetPassword();
                }
              },
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 0.1,
            ),
            NoAccountText(),
          ],
        ));
  }

  Future resetPassword() async {
    DialogBox().showDialogBox(context);
    try {
      await _auth.sendPasswordResetEmail(email: email.toString()).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(Snackbar()
            .snackbar("Reset Password email has been sent.", Colors.green));
      });

      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(Snackbar().snackbar(e.message.toString(), Colors.red));
      Navigator.of(context).pop();
    }
  }
}
