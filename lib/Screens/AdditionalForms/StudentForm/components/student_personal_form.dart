import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/Models/user.dart';

import '../../../../components/custom_surfix_icon.dart';
import '../../../../components/default_button.dart';
import '../../../../components/form_error.dart';
import '../../../../constants.dart';
import '../../../../size_config.dart';

class StudentPersonalForm extends StatefulWidget {
  var _User;

  StudentPersonalForm(this._User);
  @override
  State<StudentPersonalForm> createState() => _StudentPersonalFormState(_User);
}

class _StudentPersonalFormState extends State<StudentPersonalForm> {
  var _User;
  _StudentPersonalFormState(this._User);
  final _formKey = GlobalKey<FormState>();
  TextEditingController dateInput = TextEditingController();
  DateTime pickedDate = DateTime.now();

  var map = {
    "aadhar": [""],
    "dob": [""],
    "age": [""],
    "timingsDay": [""],
    "timingsSlot": [""],
  };
  String timings = "";
  String? choice;
  List<String> timingsDay = ['Weekday', 'Weekend'];
  List<String> timingsWeekday = ['5AM-8AM', '5PM-8PM'];
  List<String> timingsWeekend = ['9AM-9PM'];

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
          buildAgeFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          // RadioButtons(),
          TimingsDayDropDownList(),

          SizedBox(height: getProportionateScreenHeight(30)),
          TimingsSlotDropDownList(),
        ],
      ),
    );
  }

  TextFormField buildAadharFormField() {
    return TextFormField(
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
        labelText: "Aadhar",
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
        labelText: "Enter Date Of Birth",
        hintText: "Select your Date of Birth",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Calendar.svg"),
      ),
    );
  }

  TextFormField buildAgeFormField() {
    return TextFormField(
      autofocus: false,
      keyboardType: TextInputType.number,
      onSaved: (newValue) => _User.age = newValue,
      onChanged: (value) {
        if (value.isNotEmpty && int.parse(value) > 0) {
          removeError(error: kNamelNullError, name: "age");
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty || int.parse(value) <= 0) {
          addError(error: kAgeNullError, name: "age");
          return "";
        }
      },
      decoration: const InputDecoration(
        labelText: "Age",
        hintText: "Enter your age",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  Row TimingsDayDropDownList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Select your * \nPreference:         ",
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
                      value: _User.timingsDay,
                      hint: const Text("Select"),
                      items: timingsDay.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (value) async {
                        //to be implemented
                        setState(() {
                          _User.timingsDay = value;
                        });
                        if (value != null) {
                          removeError(
                              error: kDropdownListError, name: 'timingsDay');
                        } else {
                          addError(
                              error: kDropdownListError, name: 'timingsDay');
                        }
                      },
                      underline: Container(),
                    ))))
      ],
    );
  }

  Visibility TimingsSlotDropDownList() {
    return Visibility(
      visible: _User.timingsDay == null ? false : true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Select your Slot: ",
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
                        value: _User.timingsSlot,
                        hint: const Text("Select"),
                        items: _User.timingsDay == "Weekday"
                            ? timingsWeekday.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList()
                            : timingsWeekend.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                        onChanged: (value) async {
                          //to be implemented
                          setState(() {
                            _User.timingsSlot = value;
                          });
                          if (value != null) {
                            removeError(
                                error: kDropdownListError, name: 'timingsSlot');
                          } else {
                            addError(
                                error: kDropdownListError, name: 'timingsSlot');
                          }
                        },
                        underline: Container(),
                      ))))
        ],
      ),
    );
  }
}
