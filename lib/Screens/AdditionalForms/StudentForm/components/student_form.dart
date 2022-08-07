import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project/Models/user.dart';
import 'package:project/Screens/AdditionalForms/StudentForm/components/student_academic_form.dart';
import 'package:project/Screens/AdditionalForms/StudentForm/components/student_personal_form.dart';
import 'package:project/Screens/login_success/login_success_screen.dart';
import 'package:project/constants.dart';
import 'package:project/theme.dart';

import '../../../../components/SnackBar.dart';
import '../../../../size_config.dart';
import '../../../home/home_screen.dart';

class StudentForm extends StatefulWidget {
  StudentForm(this.User);
  var User;

  @override
  State<StudentForm> createState() => _StudentFormState(User);
}

class _StudentFormState extends State<StudentForm> {
  _StudentFormState(UserModel user);
  var User = UserModel();
  int currentStep = 0;
  late FirebaseAuth auth = FirebaseAuth.instance;

  Widget controlsBuilder(
      BuildContext context, ControlsDetails controlsDetails) {
    var islastStep = currentStep == getSteps().length - 1;
    return Column(children: [
      SizedBox(height: getProportionateScreenHeight(40)),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: getProportionateScreenWidth(150),
            // height: getProportionateScreenHeight(56),
            child: TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                primary: Colors.white,
                backgroundColor: kPrimaryColor,
              ),
              onPressed: controlsDetails.onStepCancel,
              child: Text(
                "Back",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(18),
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            width: getProportionateScreenWidth(150),
            // height: getProportionateScreenHeight(56),
            child: TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                primary: Colors.white,
                backgroundColor: kPrimaryColor,
              ),
              onPressed: controlsDetails.onStepContinue,
              child: Text(
                islastStep ? "Finish" : "Next",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(18),
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.light(primary: kPrimaryColor),
      ),
      child: Stepper(
        type: StepperType.horizontal,
        steps: getSteps(),
        currentStep: currentStep,
        controlsBuilder: controlsBuilder,
        onStepContinue: () async {
          final islastStep = currentStep == getSteps().length - 1;
          if (islastStep) {
            final uid = FirebaseAuth.instance.currentUser!.uid;
            DatabaseReference ref =
                FirebaseDatabase.instance.ref("users/$uid/additional_details");

            await ref.set({
              "aadhar": User.aadharNumber,
              "dob": User.dob,
              "age": User.age,
              "timingsDay": User.timingsDay,
              "timingsSlot": User.timingsSlot,
              "class": User.qualification,
              'institution': User.collegeName,
              'adviseClass': User.adviseClass,
              'adviseTution': User.tuition,
              'adviseCourse': User.adviseCourse,
            });

            ScaffoldMessenger.of(context).showSnackBar(
                Snackbar().snackbar("Signup Successful", Colors.green));

            Navigator.pushNamedAndRemoveUntil(
                context, HomeScreen.routeName, ModalRoute.withName('/'));
          } else {
            setState(() {
              currentStep++;
            });
          }
        },
        onStepCancel: currentStep == 0
            ? null
            : () => setState(() {
                  currentStep -= 1;
                }),
        onStepTapped: (step) => setState(() {
          currentStep = step;
        }),
      ),
    );
  }

  List<Step> getSteps() => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: Text("Personal Details"),
          content: StudentPersonalForm(User),
        ),
        Step(
          isActive: currentStep >= 1,
          title: Text("Academic Details"),
          content: StudentAcademicForm(User),
        ),
      ];
}
