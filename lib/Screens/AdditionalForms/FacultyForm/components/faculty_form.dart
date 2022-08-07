import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project/Screens/login_success/login_success_screen.dart';
import '../../../../Models/user.dart';
import '../../../../components/SnackBar.dart';
import '../../../../components/default_button.dart';
import '../../../../components/form_error.dart';
import '../../../../constants.dart';
import '../../../../size_config.dart';
import '../../../home/home_screen.dart';

class FacultyForm extends StatefulWidget {
  FacultyForm(this.User);
  var User = UserModel();

  @override
  _FacultyFormState createState() => _FacultyFormState(User);
}

class _FacultyFormState extends State<FacultyForm> {
  final _formKey = GlobalKey<FormState>();
  var _User = UserModel();
  _FacultyFormState(this._User);

  DatabaseReference ref = FirebaseDatabase.instance.ref("users");
  var map = {
    'aadharNumber': [''],
    'qualification': [''],
    'experience': [''],
    'mode': [''],
    'sharedPhone': ['']
  };
  List<String> qualifications = ['BE', 'BTech'];
  List<String> experience = ['0-5', '6-10'];
  List<String> mode = ['Online', 'Offline', 'Hybrid'];

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
        child: SingleChildScrollView(
          child: Column(children: [
            buildAadharFormField(),
            FormError(errors: map['aadharNumber']!),
            SizedBox(height: getProportionateScreenHeight(20)),
            buildCollegeNameFormField(),
            SizedBox(height: getProportionateScreenHeight(20)),
            QDropDownList(),
            FormError(errors: map['qualification']!),
            SizedBox(height: getProportionateScreenHeight(20)),
            EDropDownList(),
            FormError(errors: map['experience']!),
            SizedBox(height: getProportionateScreenHeight(20)),
            MDropDownList(),
            FormError(errors: map['mode']!),
            SizedBox(height: getProportionateScreenHeight(20)),
            RadioButtons(),
            FormError(errors: map['sharedPhone']!),
            SizedBox(height: getProportionateScreenHeight(20)),
            DefaultButton(
              text: "Submit",
              press: () async {
                if (_User.sharedPhone == null) {
                  addError(error: kDropdownListError, name: 'sharedPhone');
                }
                if (_User.qualification == null) {
                  addError(error: kDropdownListError, name: 'qualification');
                }
                if (_User.experience == null) {
                  addError(error: kDropdownListError, name: 'experience');
                }
                if (_User.mode == null) {
                  addError(error: kDropdownListError, name: 'mode');
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
                      "aadharNumber": _User.aadharNumber,
                      "qualification": _User.qualification,
                      "experience": _User.experience,
                      "preferred mode": _User.mode,
                      "college": _User.collegeName
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                      Snackbar().snackbar("Signup Successful", Colors.green));

                  Navigator.pushNamedAndRemoveUntil(
                      context, HomeScreen.routeName, ModalRoute.withName('/'));
                }
              },
            )
          ]),
        ));
  }

  Column RadioButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: getProportionateScreenWidth(300),
          child: const Text(
            "Can we share your phone number with students and parents? *",
            style: TextStyle(color: kTextColor),
            textScaleFactor: 1.2,
          ),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text("Yes", textScaleFactor: 1.2),
              Radio(
                  value: true,
                  groupValue: _User.sharedPhone,
                  onChanged: (bool? value) {
                    setState(() {
                      _User.sharedPhone = value;
                      removeError(
                          error: kDropdownListError, name: 'sharedPhone');
                    });
                  }),
              SizedBox(width: getProportionateScreenWidth(60)),
              Text(
                "No",
                textScaleFactor: 1.2,
              ),
              Radio(
                  value: false,
                  groupValue: _User.sharedPhone,
                  onChanged: (bool? value) {
                    setState(() {
                      _User.sharedPhone = value;
                      removeError(
                          error: kDropdownListError, name: 'sharedPhone');
                    });
                  })
            ])
      ],
    );
  }

  //include constraints
  TextFormField buildAadharFormField() {
    return TextFormField(
      autofocus: false,
      onSaved: (newValue) => _User.aadharNumber = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(
              error: "Please enter your aadhar number", name: "aadharNumber");
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(
              error: "Please enter your aadhar number", name: "aadharNumber");
          return "";
        }
      },
      decoration: const InputDecoration(
        labelText: "Aadhar Number *",
        hintText: "Enter your Aadhar Number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildCollegeNameFormField() {
    return TextFormField(
      autofocus: false,
      onSaved: (newValue) => _User.collegeName = newValue,
      onChanged: (value) {},
      //   if (value.isNotEmpty) {
      //     removeError(error: "Please enter your college name",name:"collegeName");
      //   }
      //   return;
      // },
      // validator: (value) {
      //   if (value!.isEmpty) {
      //     addError(error: "Please enter your college name",name:"collegeName");
      //     return "";
      //   }
      // },
      decoration: const InputDecoration(
        labelText: "College Name *",
        hintText: "Enter your College Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  Row QDropDownList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Educational *\nQualification",
          textScaleFactor: 1.2,
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
                      value: _User.qualification,
                      hint: const Text("Select"),
                      items: qualifications.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? value) async {
                        setState(() {
                          _User.qualification = value;
                        });
                        if (value != null) {
                          removeError(
                              error: kDropdownListError, name: 'qualification');
                        } else {
                          addError(
                              error: kDropdownListError, name: 'qualification');
                        }
                      },
                      underline: Container(),
                    ))))
      ],
    );
  }

  Row EDropDownList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Experience *  \n(in years)  ",
          textScaleFactor: 1.2,
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
                      value: _User.experience,
                      hint: const Text("Select"),
                      items: experience.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? value) async {
                        setState(() {
                          _User.experience = value;
                        });
                        if (value != null) {
                          removeError(
                              error: kDropdownListError, name: 'experience');
                        } else {
                          addError(
                              error: kDropdownListError, name: 'experience');
                        }
                      },
                      underline: Container(),
                    ))))
      ],
    );
  }

  Row MDropDownList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Preferred *    \nMode    ",
          textScaleFactor: 1.2,
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
                      value: _User.mode,
                      hint: const Text("Select"),
                      items: mode.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? value) async {
                        setState(() {
                          _User.mode = value;
                        });
                        if (value != null) {
                          removeError(error: kDropdownListError, name: 'mode');
                        }
                      },
                      underline: Container(),
                    ))))
      ],
    );
  }
}
