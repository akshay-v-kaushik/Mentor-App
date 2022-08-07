import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project/components/form_error.dart';

import '../../../Models/user.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class Faculty extends StatefulWidget {
  const Faculty({Key? key}) : super(key: key);

  @override
  State<Faculty> createState() => _FacultyState();
}

class _FacultyState extends State<Faculty> {
  final _formKey = GlobalKey<FormState>();
  final _User = UserModel();
  String collegeName = "";
  DatabaseReference? _dbref;
  var uid = FirebaseAuth.instance.currentUser!.uid;
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

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
    _dbref = FirebaseDatabase.instance.ref('users');
    getData();
  }

  void getData() {
    _dbref!
        .child(uid)
        .child('additional_details')
        .child('college')
        .onValue
        .listen((DatabaseEvent event) {
      final data = event.snapshot.value.toString();
      print(data);
      setState(() {
        collegeName = data;
      });
    });
  }

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
          Text(
            "Additional Details",
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.start,
            textScaleFactor: 1.5,
          ),
          SizedBox(height: getProportionateScreenHeight(40)),
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
          SizedBox(height: getProportionateScreenHeight(30)),
        ])));
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

  TextFormField buildCollegeNameFormField() {
    return TextFormField(
      key: collegeName.isEmpty ? Key("College Name") : Key(collegeName),
      initialValue: collegeName,
      autofocus: false,
      onSaved: (newValue) => collegeName = newValue!,
      onChanged: (value) {},
      decoration: const InputDecoration(
        labelText: "College Name *",
        hintText: "Enter your College Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
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
