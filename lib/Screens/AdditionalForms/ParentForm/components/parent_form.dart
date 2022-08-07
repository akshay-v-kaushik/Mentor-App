// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:project/Models/user.dart';
import 'package:project/Screens/otp/otp_screen.dart';
import 'package:project/components/firebase_verification.dart';
import 'package:project/size_config.dart';
import '../../../../components/SnackBar.dart';
import '../../../../components/custom_surfix_icon.dart';
import '../../../../components/default_button.dart';
import '../../../../components/form_error.dart';
import '../../../../constants.dart';
import '../../../home/home_screen.dart';
import '../../../login_success/login_success_screen.dart';

class ParentForm extends StatefulWidget {
  var _User;

  ParentForm(this._User);

  @override
  _ParentFormState createState() => _ParentFormState(_User);
}

class _ParentFormState extends State<ParentForm> {
  final _formKey = GlobalKey<FormState>();
  var _User = UserModel();
  TextEditingController dateInput = TextEditingController();
  DateTime pickedDate = DateTime.now();
  bool postGradBox = false;

  var map = {
    "aadhar": [""],
    "dob": [""],
    "advise": [""],
    "postgrad": [""],
  };
  List<String> advise = ['IX', 'X', 'XI', 'XII', 'SAT', 'Post Graduation'];
  List<String> postGrad = ['GRE', 'TOEFL', 'IELTS', 'GATE', 'GMAT', 'PLAB'];
  late FirebaseAuth auth = FirebaseAuth.instance;
  String? _VerificationCode;
  String? _message;

  _ParentFormState(this._User);

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
          buildAadharFormField(),
          FormError(errors: map["aadhar"]!),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildDOBFormField(),
          FormError(errors: map["dob"]!),
          SizedBox(height: getProportionateScreenHeight(30)),
          AdviseDropDownList(),
          FormError(errors: map["advise"]!),
          SizedBox(height: getProportionateScreenHeight(30)),
          postGradBox
              ? PostGradDropDownList()
              : SizedBox(
                  height: 30,
                ),
          FormError(errors: map["postgrad"]!),
          SizedBox(height: getProportionateScreenHeight(220)),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: DefaultButton(
              text: "Continue",
              press: () async {
                if (_User.advise == null) {
                  addError(error: kDropdownListError, name: 'advise');
                }
                if (_User.postGrad == null &&
                    _User.advise == "Post Graduation") {
                  addError(error: kDropdownListError, name: 'postgrad');
                }
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  final uid = FirebaseAuth.instance.currentUser!.uid;
                  DatabaseReference ref =
                      FirebaseDatabase.instance.ref("users/$uid");

                  await ref.set({
                    "basic_details": {
                      "email": _User.email,
                      "name": _User.name,
                      "phone": _User.phoneNumber,
                      "type": _User.type,
                    },
                    "additional_details": {
                      "aadhar": _User.aadharNumber,
                      "dob": _User.dob,
                      "advise": _User.advise,
                      "postgrad": _User.postGrad,
                    }
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                      Snackbar().snackbar("Signup Successful", Colors.green));

                  Navigator.pushNamedAndRemoveUntil(
                      context, HomeScreen.routeName, ModalRoute.withName('/'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  TextFormField buildAadharFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      autofocus: false,
      onSaved: (newValue) => _User.aadharNumber = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAadharNullError, name: "aadhar");
        }
        if (aadharValidator.hasMatch(value)) {
          removeError(error: kAadharInvalidError, name: "aadhar");
        }
        _User.aadharNumber = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kAadharNullError, name: "aadhar");
          return "";
        }
        if (!aadharValidator.hasMatch(value)) {
          addError(error: kAadharInvalidError, name: "aadhar");
          return "";
        }
      },
      decoration: const InputDecoration(
        labelText: "Aadhar *",
        hintText: "Enter your Aadhar number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildDOBFormField() {
    return TextFormField(
      readOnly: true,
      autofocus: false,
      controller: dateInput,
      onTap: () async {
        pickedDate = (await showDatePicker(
          context: context,
          initialDate: pickedDate,
          firstDate: DateTime(1900),
          lastDate: DateTime(2101),
        ))!;

        if (pickedDate != null) {
          print(pickedDate);
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          print(formattedDate);
          removeError(error: kDOBNullError, name: "dob");

          setState(() {
            dateInput.text = formattedDate;
            _User.dob = formattedDate;
          });
        } else {
          print("Date is not selected");
        }
      },
      onSaved: (newValue) => _User.dob = newValue.toString(),
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kDOBNullError, name: "dob");
          return "";
        }
      },
      decoration: const InputDecoration(
        labelText: "Enter Date Of Birth *",
        hintText: "Select your Date of Birth",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Calendar.svg"),
      ),
    );
  }

  Row AdviseDropDownList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Seeking Academic *\n            Advice For:",
          textScaleFactor: 1.1,
        ),
        // SizedBox(
        //   width: getProportionateScreenWidth(30),
        // ),
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
                      value: _User.advise,
                      hint: const Text("Select"),
                      items: advise.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? value) async {
                        setState(() {
                          if (value == "Post Graduation") {
                            postGradBox = true;
                          } else {
                            postGradBox = false;
                            _User.postGrad = null;
                          }
                          _User.advise = value;
                        });
                        if (value != null) {
                          removeError(
                              error: kDropdownListError, name: 'advise');
                        } else {
                          addError(error: kDropdownListError, name: 'advise');
                        }
                      },
                      underline: Container(),
                    ))))
      ],
    );
  }

  Visibility PostGradDropDownList() {
    return Visibility(
      visible: postGradBox ? true : false,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Select Your Exam: *",
            textScaleFactor: 1.1,
          ),
          // SizedBox(
          //   width: getProportionateScreenWidth(30),
          // ),
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
                        value: _User.postGrad,
                        hint: const Text("Select"),
                        items: postGrad.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String? value) async {
                          setState(() {
                            _User.postGrad = value;
                          });
                          if (value != null) {
                            removeError(
                                error: kDropdownListError, name: 'postgrad');
                          } else {
                            addError(
                                error: kDropdownListError, name: 'postgrad');
                          }
                        },
                        underline: Container(),
                      ))))
        ],
      ),
    );
  }
}
