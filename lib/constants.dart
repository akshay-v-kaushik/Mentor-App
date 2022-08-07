import 'package:flutter/material.dart';
import 'package:project/size_config.dart';

const kPrimaryColor = Color.fromRGBO(111, 53, 165, 1);
const kPrimaryLightColor = Color.fromARGB(255, 231, 208, 253);
const kErrorColor = Color.fromRGBO(128, 0, 0, 1);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color.fromRGBO(140, 93, 183, 1), Color.fromRGBO(89, 42, 132, 1)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(20),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
// final RegExp passwordValidatorRegExp =
// RegExp(r"^(?=.*?[A-Z])(?=(.*[a-z]){1,})(?=(.*[\d]){1,})(?=(.*[\W]){1,})(?!.*\s).{8,}$");
final RegExp phoneNumberValidator =
    RegExp(r"^(\+91[\-\s]?)?[0]?(91)?[789]\d{9}$");

// final RegExp emailValidatorRegExp =
//     RegExp(r'[^A-Za-z0-9]{1,20}');
final RegExp passwordValidatorRegExp = RegExp(r".{8,}$");
// final RegExp aadharValidator =
//     RegExp(r"^[2-9]{1}[0-9]{3}[0-9]{4}[0-9]{4}$");
final RegExp aadharValidator =
    RegExp(r"^[2-9]{1}[0-9]{11}$");
const String kAgeNullError = "Please Enter a Valid Age";
const String kDOBNullError = "Please Enter a Date of Birth";
const String kAadharInvalidError = "Please Enter Valid Aadhar";
const String kAadharNullError = "Please Enter your Aadhar";
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kInvalidPassError = "Password must contain atleast 8 characters";
const String kPassRules =
    "-Atleast 8 characters\n-Atleast 1 uppercase and 1 lower letter\n-Atleast 1 digit\n-Atleast 1 special character";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kValidPhoneNumber = "Please enter a valid phone number";
const String kAddressNullError = "Please Enter your address";
const String kDropdownListError = "Please select any one of the options";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: const BorderSide(color: kTextColor),
  );
}
