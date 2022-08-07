import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../Models/user.dart';
import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class BasicForm extends StatefulWidget {
  const BasicForm({Key? key}) : super(key: key);

  @override
  State<BasicForm> createState() => _BasicFormState();
}

class _BasicFormState extends State<BasicForm> {
  String name = "", phoneNumber = "", email = "", aadharNumber = "";
  final _formKey = GlobalKey<FormState>();
  DatabaseReference? _dbref;
  DatabaseReference? ref;
  var uid = FirebaseAuth.instance.currentUser!.uid;

  // final = UserModel();
  var map = {
    "fname": [""],
    "phone": [""],
    "email": [""],
    "dropdown": [""],
    "aadhar": [""]
  };
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
        .child('basic_details')
        .child('name')
        .onValue
        .listen((DatabaseEvent event) {
      final data = event.snapshot.value.toString();
      print(data);
      setState(() {
        name = data;
      });
    });
    _dbref!
        .child(uid)
        .child('additional_details')
        .child('aadhar')
        .onValue
        .listen((DatabaseEvent event) {
      final data = event.snapshot.value.toString();
      print(data);
      setState(() {
        aadharNumber = data;
      });
    });
    _dbref!
        .child(uid)
        .child('basic_details')
        .child('phone')
        .onValue
        .listen((DatabaseEvent event) {
      final data = event.snapshot.value.toString();
      //print(data);
      setState(() {
        phoneNumber = data;
      });
      print(phoneNumber);
    });
    _dbref!
        .child(uid)
        .child('basic_details')
        .child('email')
        .onValue
        .listen((DatabaseEvent event) {
      final data = event.snapshot.value.toString();
      print(data);
      setState(() {
        email = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // ref = FirebaseDatabase.instance.ref("users/$uid");
    // print(ref.toString());
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(children: [
          Text(
            "Basic Details",
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.start,
            textScaleFactor: 1.5,
          ),
          SizedBox(height: getProportionateScreenHeight(40)),
          buildNameFormField(),
          FormError(errors: map["fname"]!),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPhoneNumberFormField(),
          FormError(errors: map["phone"]!),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildEmailFormField(),
          FormError(errors: map["email"]!),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildAadharFormField(),
          // SizedBox(height: getProportionateScreenHeight(30)),
          // TextButton(
          //     onPressed: () async {
          //       print(uid);
          //       ref = FirebaseDatabase.instance.ref("users/$uid");

          //       await ref!.child('basic_details').update({
          //         'name': name,
          //         'email': email,
          //         'phone': phoneNumber,
          //       });
          //     },
          //     child: Text("Save")),
          // FormError(errors: map["aadhar"]!),
        ])));
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

  TextFormField buildAadharFormField() {
    return TextFormField(
      key: aadharNumber.isEmpty
          ? Key("Aadhar Number")
          : Key(aadharNumber.toString()),
      keyboardType: TextInputType.number,
      autofocus: false,
      initialValue: aadharNumber,
      onSaved: (newValue) => aadharNumber = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAadharNullError, name: "aadhar");
        }
        if (aadharValidator.hasMatch(value)) {
          removeError(error: kAadharInvalidError, name: "aadhar");
        }
        aadharNumber = value;
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

  TextFormField buildEmailFormField() {
    return TextFormField(
      key: email.isEmpty ? Key("email") : Key(email.toString()),
      autofocus: false,
      initialValue: email,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue!,
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
        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      key: phoneNumber.isEmpty
          ? Key("Phone Number")
          : Key(phoneNumber.toString()),
      initialValue: phoneNumber,
      autofocus: false,
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => phoneNumber = newValue!,
      onChanged: (value) {},
      validator: (value) {},
      decoration: const InputDecoration(
        labelText: "Phone Number",
        hintText: "Enter your phone number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      key: name.isEmpty ? Key("Username") : Key(name.toString()),
      initialValue: name,
      autofocus: false,
      onSaved: (newValue) => name = newValue!,
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
        labelText: "Name",
        hintText: "Enter your name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}
