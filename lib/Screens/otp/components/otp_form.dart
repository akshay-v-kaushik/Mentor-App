import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/Models/user.dart';
import 'package:project/Screens/AdditionalForms/ParentForm/parent_screen.dart';
import 'package:timer_button/timer_button.dart';
import '../../../components/SnackBar.dart';
import '../../../components/default_button.dart';
import '../../../components/firebase_verification.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../AdditionalForms/FacultyForm/faculty_screen.dart';
import '../../AdditionalForms/StudentForm/student_screen.dart';

class OtpForm extends StatefulWidget {
  var User = UserModel();
  OtpForm(this.User);

  @override
  _OtpFormState createState() => _OtpFormState(User);
}

class _OtpFormState extends State<OtpForm> {
  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;
  FocusNode? pin5FocusNode;
  FocusNode? pin6FocusNode;

  String _VerificationCode = "";
  String _verificationId = "";
  late PhoneAuthCredential credential;

  FirebaseAuth auth = FirebaseAuth.instance;
  var User = UserModel();
  

  _OtpFormState(this.User);

  @override
  void initState() {
    super.initState();
    verifyPhone(User.phoneNumber.toString());

    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pin2FocusNode!.dispose();
    pin3FocusNode!.dispose();
    pin4FocusNode!.dispose();
    pin5FocusNode!.dispose();
    pin6FocusNode!.dispose();
  }

  void nextField(String value, FocusNode? focusNode) {
    if (value.length == 1) {
      focusNode!.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.15),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            SizedBox(
              width: getProportionateScreenWidth(40),
              child: TextFormField(
                autofocus: true,
                obscureText: true,
                style: const TextStyle(fontSize: 24),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: otpInputDecoration,
                onChanged: (value) {
                  _VerificationCode = (_VerificationCode + value);
                  nextField(value, pin2FocusNode);
                },
              ),
            ),
            SizedBox(
              width: getProportionateScreenWidth(40),
              child: TextFormField(
                  focusNode: pin2FocusNode,
                  obscureText: true,
                  style: const TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    _VerificationCode = (_VerificationCode + value);
                    nextField(value, pin3FocusNode);
                  }),
            ),
            SizedBox(
              width: getProportionateScreenWidth(40),
              child: TextFormField(
                  focusNode: pin3FocusNode,
                  obscureText: true,
                  style: const TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    _VerificationCode = (_VerificationCode + value);
                    nextField(value, pin4FocusNode);
                  }),
            ),
            SizedBox(
              width: getProportionateScreenWidth(40),
              child: TextFormField(
                  focusNode: pin4FocusNode,
                  obscureText: true,
                  style: const TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    _VerificationCode = (_VerificationCode + value);
                    nextField(value, pin5FocusNode);
                  }),
            ),
            SizedBox(
              width: getProportionateScreenWidth(40),
              child: TextFormField(
                  focusNode: pin5FocusNode,
                  obscureText: true,
                  style: const TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    _VerificationCode = (_VerificationCode + value);
                    nextField(value, pin6FocusNode);
                  }),
            ),
            SizedBox(
              width: getProportionateScreenWidth(40),
              child: TextFormField(
                focusNode: pin6FocusNode,
                obscureText: true,
                style: const TextStyle(fontSize: 24),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: otpInputDecoration,
                onChanged: (value) async {
                  if (value.length == 1) {
                    _VerificationCode = (_VerificationCode + value);

                    pin4FocusNode!.unfocus();
                  }
                },
              ),
            ),
          ]),
          SizedBox(height: SizeConfig.screenHeight * 0.33),
          //  TimerButton(
          //         label: "Send OTP Again",
          //         timeOutInSeconds: 30,
          //         onPressed: () {},
          //         disabledColor: Colors.red,
          //         color: kPrimaryColor,
          //         disabledTextStyle: const TextStyle(fontSize: 20.0),
          //         activeTextStyle: const TextStyle(fontSize: 20.0, color: Colors.white),
          //       ),
          // SizedBox(height: getProportionateScreenHeight(30)),
          Align(
            alignment: Alignment.bottomCenter,
            child: DefaultButton(
              text: "Continue",
              press: () async {
                if (_VerificationCode.toString().length == 6) {
                  credential = PhoneAuthProvider.credential(
                      verificationId: _verificationId,
                      smsCode: _VerificationCode);
                      String? message = await AuthenticationService(auth)
                      .signUp(email: User.email, password: User.password);
                      String  response = await PhoneAuth(credential);
                  
                  if (message == "Signed up"&&response=="Signed in") {
                    ScaffoldMessenger.of(context).showSnackBar(
                        Snackbar().snackbar("Signup Successful", Colors.green));
                    if (User.type == "Faculty") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FacultyScreen(User),
                          ));
                    } else if (User.type == "Parent") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ParentFormScreen(User),
                          ));
                    } else if (User.type == "Student") {
                      final uid = FirebaseAuth.instance.currentUser!.uid;
                      DatabaseReference ref = FirebaseDatabase.instance
                          .ref("users/$uid/basic_details");

                      await ref.set({
                        "email": User.email,
                        "name": User.name,
                        "phone": User.phoneNumber,
                        "type": User.type,
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentScreen(User),
                          ));
                    }
                  } else {
                    if(message!="Signed up") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        Snackbar().snackbar(message.toString(), Colors.red));
                    }
                    else if(response!="Signed in") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        Snackbar().snackbar(response.toString(), Colors.red));
                    }
                  }
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> verifyPhone(String phoneNumber) async {  
    int? resToken; 
    try{
    await auth.verifyPhoneNumber(
        phoneNumber: '+91 $phoneNumber',
        codeSent: (String verificationId, [int? resendToken]) async {
                ScaffoldMessenger.of(context).showSnackBar(
                        Snackbar().snackbar("Verification code sent", Colors.green));
                        setState(() {
                          _verificationId = verificationId;
                          resToken = resendToken;
                        });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          ScaffoldMessenger.of(context).showSnackBar(
                        Snackbar().snackbar("Timeout", Colors.red));
        },
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          ScaffoldMessenger.of(context).showSnackBar(
                        Snackbar().snackbar("Verification Completed", Colors.green));
        },
        verificationFailed: (FirebaseAuthException error) {
          ScaffoldMessenger.of(context).showSnackBar(
                        Snackbar().snackbar(error.toString(), Colors.red));
        },
        forceResendingToken: resToken,
        timeout: const Duration(seconds: 30)
    );
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
                        Snackbar().snackbar(e.toString(), Colors.red));
    }
  }

  Future<String> PhoneAuth(credential) async {
    String msg;
    try {
      await auth.currentUser?.linkWithCredential(credential);
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "provider-already-linked":
          msg =  "The provider has already been linked to the user.";
          break;
          
        case "invalid-credential":
          msg = "The provider's credential is not valid.";
          break;
          
        case "credential-already-in-use":
          msg = "The account corresponding to the credential already exists, "
                  "or is already linked to another User.";
                  break;
        case "invalid-verification-id":
          msg =  "Invalid OTP.";
          break;
          
          case "invalid-verification-code": msg =  "Invalid OTP.";
          break;
          
        // See the API reference for the full list of error codes.
        default:
          msg = "Unknown error.";
      }
      await auth.currentUser?.delete();
      return msg;
    }
  }
}
