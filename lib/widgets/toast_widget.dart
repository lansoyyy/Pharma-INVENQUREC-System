import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharma_invenqurec/utlis/colors.dart';

Future<bool?> showToast(msg) {
  return Fluttertoast.showToast(
    backgroundColor: primary,
    toastLength: Toast.LENGTH_LONG,
    msg: msg,
  );
}
