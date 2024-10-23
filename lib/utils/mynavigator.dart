import 'package:flutter/material.dart';

navigatorPush({required BuildContext context, required Widget page}) async {
  return await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}
