import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../../Models/user.dart';
import '../../../../components/SnackBar.dart';
import '../../../../components/default_button.dart';
import '../../../../components/form_error.dart';
import '../../../../constants.dart';
import '../../../../size_config.dart';
import '../../../login_success/login_success_screen.dart';

class StudentAcademicForm extends StatefulWidget {
  StudentAcademicForm(this.User);
  var User;

  @override
  State<StudentAcademicForm> createState() => _StudentAcademicFormState(User);
}

class _StudentAcademicFormState extends State<StudentAcademicForm> {
  final _formKey = GlobalKey<FormState>();
  var User;
  _StudentAcademicFormState(this.User);

  DatabaseReference ref = FirebaseDatabase.instance.ref("users");
  var map = {
    'class': [''],
    'institution': [''],
    'adviseClass': [''],
    'adviseTution': [''],
    'adviseCourse': [''],
  };
  List<String> classStudyingIn = ['IX', 'X', 'XI', 'XII'];
  List<String> tuition = ['Yes', 'No'];
  List<String> adviseClass = [
    'X',
    'XI',
    'XII',
    'Under Graduation',
    'Post Graduation'
  ];
  List<String> adviseCourse = ['NEET', 'CLAT', 'JEE Mains', 'JEE Advanced'];

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
      child: Column(children: [
        buildInstitutionFormField(),
        FormError(errors: map['institution']!),
        SizedBox(height: getProportionateScreenHeight(20)),
        ClassDropDownList(),
        FormError(errors: map['class']!),
        SizedBox(height: getProportionateScreenHeight(20)),
        adviseClassDropDownList(),
        FormError(errors: map['adviseClass']!),
        SizedBox(height: getProportionateScreenHeight(20)),
        adviseCourseDropDownList(),
        FormError(errors: map['adviseCourse']!),
        SizedBox(height: getProportionateScreenHeight(20)),
        TuitionDropDownList(),
        FormError(errors: map['adviseTution']!),
        SizedBox(height: getProportionateScreenHeight(20)),
      ]),
    );
  }

  //include constraints

  TextFormField buildInstitutionFormField() {
    return TextFormField(
      autofocus: false,
      onSaved: (newValue) => User.collegeName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(
              error: "Please enter your college/school name",
              name: "institution");
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(
              error: "Please enter your college/school name",
              name: "institution");
          return "";
        }
      },
      decoration: const InputDecoration(
        labelText: "College/School Name *",
        hintText: "Enter your College/School Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  Row TuitionDropDownList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Seeking advise for *\nprivate tutions? ",
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
                      value: User.tuition,
                      hint: const Text("Select"),
                      items: tuition.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (value) async {
                        setState(() {
                          User.tuition = value;
                        });
                        if (value != null) {
                          removeError(
                              error: kDropdownListError, name: 'tuition');
                        }
                      },
                      underline: Container(),
                    ))))
      ],
    );
  }

  Row ClassDropDownList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Studying in? *          ",
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
                      value: User.qualification,
                      hint: const Text("Select"),
                      items: classStudyingIn.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (value) async {
                        setState(() {
                          User.qualification = value;
                        });
                        if (value != null) {
                          removeError(error: kDropdownListError, name: 'class');
                        }
                      },
                      underline: Container(),
                    ))))
      ],
    );
  }

  Row adviseClassDropDownList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Seeking advise for *\n(class)",
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
                      value: User.adviseClass,
                      hint: const Text("Select"),
                      items: adviseClass.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (value) async {
                        setState(() {
                          User.adviseClass = value.toString();
                        });
                        if (value != null) {
                          removeError(
                              error: kDropdownListError, name: 'adviseClass');
                        }
                      },
                      underline: Container(),
                    ))))
      ],
    );
  }

  Row adviseCourseDropDownList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Seeking advise for *\n(Course)",
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
                      value: User.adviseCourse,
                      hint: const Text("Select"),
                      items: adviseCourse.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (value) async {
                        setState(() {
                          User.adviseCourse = value;
                        });
                        if (value != null) {
                          removeError(
                              error: kDropdownListError, name: 'adviseCourse');
                        }
                      },
                      underline: Container(),
                    ))))
      ],
    );
  }
}
