
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project/Models/user.dart';
import 'package:project/Screens/otp/otp_screen.dart';
import 'package:project/components/firebase_verification.dart';
import '../../../components/SnackBar.dart';
import '../../../components/custom_surfix_icon.dart';
import '../../../components/default_button.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../AdditionalForms/FacultyForm/faculty_screen.dart';
import '../../AdditionalForms/ParentForm/parent_screen.dart';
import '../../AdditionalForms/StudentForm/student_screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _User = UserModel();
  var map = {
    "fname": [""],
    "phone": [""],
    "email": [""],
    "password": [""],
    "cpass": [""],
    "dropdown": [""]
  };
  var items = ['Student', 'Parent', 'Faculty'];

  late FirebaseAuth auth = FirebaseAuth.instance;
  // AuthenticationService fob= AuthenticationService(auth);
  bool passwordText1 = false;
  String svgicon1 = "assets/icons/PasswordHidden.svg";
  bool passwordText2 = false;
  String svgicon2 = "assets/icons/PasswordHidden.svg";

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
          buildNameFormField(),
          FormError(errors: map["fname"]!),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildPhoneNumberFormField(),
          FormError(errors: map["phone"]!),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildEmailFormField(),
          FormError(errors: map["email"]!),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildPasswordFormField(),
          FormError(errors: map["password"]!),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildConformPassFormField(),
          FormError(errors: map["cpass"]!),
          SizedBox(height: getProportionateScreenHeight(20)),
          DropDownList(),
          FormError(errors: map["dropdown"]!),
          SizedBox(height: getProportionateScreenHeight(15)),
          const SizedBox(
            child: Text("We value your privacy. Your data will not be shared."),
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Continue",
            press: () async {
              if (_User.type == null) {
                _formKey.currentState!.validate();
                addError(error: kDropdownListError, name: "dropdown");
              }

              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                if (!(_User.phoneNumber == "" || _User.phoneNumber == null)) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtpScreen(_User),
                      ));
                } else {
                  String? message = await AuthenticationService(auth)
                      .signUp(email: _User.email, password: _User.password);
                  if (message == "Signed up") {
                    ScaffoldMessenger.of(context).showSnackBar(
                        Snackbar().snackbar("Signup Successful", Colors.green));
                    if (_User.type == "Faculty") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FacultyScreen(_User),
                          ));
                    } else if (_User.type == "Parent") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ParentFormScreen(_User),
                          ));
                    } else if (_User.type == "Student") {
                      final uid = FirebaseAuth.instance.currentUser!.uid;
                      DatabaseReference ref = FirebaseDatabase.instance
                          .ref("users/$uid/basic_details");

                      await ref.set({
                        "email": _User.email,
                        "name": _User.name,
                        "phone": _User.phoneNumber,
                        "type": _User.type,
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentScreen(_User),
                          ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          Snackbar().snackbar(message.toString(), Colors.red));
                    }
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => OtpScreen(_User),
                    //     ));
                  }
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Row DropDownList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Who are you? *",
          textScaleFactor: 1.2,
        ),
        SizedBox(
          width: getProportionateScreenWidth(30),
        ),
        SizedBox(
            height: 30,
            width: 150,
            child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),

                  border: Border.all(
                    color: kTextColor,
                    width: 1,
                  ), //border of dropdown button
                ),
                child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 5, 3),
                    child: DropdownButton(
                      borderRadius: BorderRadius.circular(28),
                      isExpanded: true,
                      value: _User.type,
                      hint: const Text("Select"),
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _User.type = value;

                          print(_User.type);
                          if (_User.type != null) {
                            removeError(
                                error: kDropdownListError, name: 'dropdown');
                          } //else {
                          //   addError(error: kDropdownListError);
                          // }
                        });
                      },
                      underline: Container(),
                    ))))
      ],
    );
  }

  TextFormField buildConformPassFormField() {
    return TextFormField(
      autofocus: false,
      obscureText: passwordText2 ? false : true,
      onSaved: (newValue) => _User.confirm_password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError, name: "cpass");
        }
        if (_User.password == value) {
          removeError(error: kMatchPassError, name: "cpass");
        }
        _User.confirm_password = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError, name: "cpass");
          return "";
        } else if ((_User.password != value)) {
          addError(error: kMatchPassError, name: "cpass");
          return "";
        }
      },
      decoration: InputDecoration(
        labelText: "Confirm Password *",
        hintText: "Re-enter your password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
            svgIcon: svgicon2,
            tap: () {
              setState(() {
                passwordText2 = !passwordText2;
                if (passwordText2) {
                  svgicon2 = "assets/icons/PasswordView.svg";
                } else {
                  svgicon2 = "assets/icons/PasswordHidden.svg";
                }
              });
            }),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      autofocus: false,
      obscureText: passwordText1 ? false : true,
      onSaved: (newValue) => _User.password = newValue,
      onChanged: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError, name: "password");
        } else if (!passwordValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidPassError, name: "password");
        }
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
        labelText: "Password *",
        hintText: "Enter your password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
            svgIcon: svgicon1,
            tap: () {
              setState(() {
                passwordText1 = !passwordText1;
                if (passwordText1) {
                  svgicon1 = "assets/icons/PasswordView.svg";
                } else {
                  svgicon1 = "assets/icons/PasswordHidden.svg";
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
      onSaved: (newValue) => _User.email = newValue,
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
        labelText: "Email *",
        hintText: "Enter your email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      autofocus: false,
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => _User.phoneNumber = newValue,
      onChanged: (value) {},
      validator: (value) {},
      decoration: const InputDecoration(
        labelText: "Phone Number (optional)",
        hintText: "Enter your phone number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      autofocus: false,
      onSaved: (newValue) => _User.name = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError, name: "fname");
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kNamelNullError, name: "fname");
          return "";
        }
      },
      decoration: const InputDecoration(
        labelText: "Name *",
        hintText: "Enter your name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}
