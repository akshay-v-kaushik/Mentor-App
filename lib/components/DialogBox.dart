import 'package:flutter/material.dart';

class DialogBox {
  Future showDialogBox(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));
  }
}
