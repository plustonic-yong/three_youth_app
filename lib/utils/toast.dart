import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String message) {
  Fluttertoast.showToast(msg: message, backgroundColor: Colors.grey[700], toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, fontSize: 18);
}
