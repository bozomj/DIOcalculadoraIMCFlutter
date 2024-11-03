import 'package:flutter/material.dart';

navigatorPush({required BuildContext context, required Widget page}) async {
  return await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}

navigatorPushReplacement(
    {required BuildContext context, required Widget page}) async {
  Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (context) => page), (v) => false);
}
