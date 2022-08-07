import 'package:flutter/material.dart';

class Snackbar {
  SnackBar snackbar(String text, Color bgcolor) {
    return SnackBar(
      content: Text(
        text,
        textAlign: TextAlign.center,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
      ),
      backgroundColor: bgcolor,
    );
  }
}
