
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void dismissKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

void superPrint(var content, {var title = 'Super Print'}) {
  String callerFrame = '';

  if (kDebugMode) {
    try {
      final stackTrace = StackTrace.current;
      final frames = stackTrace.toString().split("\n");
      callerFrame = frames[1];
    } catch (e1) {
      debugPrint(e1.toString(), wrapWidth: 1024);
    }

    DateTime dateTime = DateTime.now();
    String dateTimeString =
        '${dateTime.hour} : ${dateTime.minute} : ${dateTime.second}.${dateTime.millisecond}';
    debugPrint('', wrapWidth: 1024);
    debugPrint(
        '- ${title.toString()} - ${callerFrame.split('(').last.replaceAll(')', '')}',
        wrapWidth: 1024);
    debugPrint('____________________________');
    try {
      debugPrint(
          const JsonEncoder.withIndent('  ')
              .convert(const JsonDecoder().convert(content)),
          wrapWidth: 1024);
    } catch (e1, e2) {
      try {
        debugPrint(
            const JsonEncoder.withIndent('  ')
                .convert(const JsonDecoder().convert(jsonEncode(content))),
            wrapWidth: 1024);
      } catch (e1, e2) {
        debugPrint(content.toString());
        // saveLogFromException(e1,e2);;
      }
      // saveLogFromException(e1,e2);;
    }
    debugPrint('____________________________ $dateTimeString');
  }
}


class MyFunctions{

  static bool isSameDay({required DateTime dateTime1, required DateTime dateTime2}) {
    return dateTime1.toString().substring(0, 10) ==
        dateTime2.toString().substring(0, 10);
  }
  static Size getMediaQuerySize({required BuildContext context}){
    return MediaQuery.sizeOf(context);
  }

  static bool isValidEmail(String email) {
    // Define the regular expression for validating an email
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    // Return true if the email matches the regex, otherwise false
    return emailRegex.hasMatch(email);
  }

}