import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AlertBox {
  AlertBox(message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0);
  }
}
