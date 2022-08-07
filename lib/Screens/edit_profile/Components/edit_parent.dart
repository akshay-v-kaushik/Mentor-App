import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../Models/user.dart';
import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class Parent extends StatefulWidget {
  const Parent({Key? key}) : super(key: key);

  @override
  State<Parent> createState() => _ParentState();
}

class _ParentState extends State<Parent> {
  final _formKey = GlobalKey<FormState>();
  var _User = UserModel();
  TextEditingController dateInput = TextEditingController();
  DateTime pickedDate = DateTime.now();
  bool postGradBox = false;
  DatabaseReference? _dbref;
  var uid = FirebaseAuth.instance.currentUser!.uid;
  String dob = "";
  var map = {
    "aadhar": [""],
    "dob": [""],
    "advise": [""],
    "postgrad": [""],
  };
  List<String> advise = ['IX', 'X', 'XI', 'XII', 'SAT', 'Post Graduation'];
  List<String> postGrad = ['GRE', 'TOEFL', 'IELTS', 'GATE', 'GMAT', 'PLAB'];

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
        .child('dob')
        .onValue
        .listen((DatabaseEvent event) {
      final data = event.snapshot.value.toString();
      print(data);
      setState(() {
        dob = data;
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
        child: Column(children: [
          Text(
            "Additional Details",
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.start,
            textScaleFactor: 1.5,
          ),
          SizedBox(height: getProportionateScreenHeight(40)),
          buildDOBFormField(),
          FormError(errors: map["dob"]!),
          SizedBox(height: getProportionateScreenHeight(30)),
          AdviseDropDownList(),
          FormError(errors: map["advise"]!),
          SizedBox(height: getProportionateScreenHeight(30)),
          PostGradDropDownList(),
          FormError(errors: map["postgrad"]!),
          SizedBox(height: getProportionateScreenHeight(220)),
        ]));
  }

  TextFormField buildDOBFormField() {
    // var initdate = DateFormat("yyyy-MM-dd").parse(dob);
    return TextFormField(
      // key: dob.isEmpty ? Key("Date of Birth") : Key(dob),
      // initialValue: dob,
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
            dob = formattedDate;
          });
        } else {
          print("Date is not selected");
        }
      },
      onSaved: (newValue) => dob = newValue.toString(),
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
                          // if (value == "Post Graduation") {
                          //   postGradBox = true;
                          // } else {
                          //   postGradBox = false;
                          //   _User.postGrad = null;
                          // }
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
      // visible: postGradBox ? true : false,
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
