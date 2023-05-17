
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:intl/intl.dart';
import 'package:tictactoe_game/services/string_extensions.dart';

import '../models/game.dart';
import '../models/player.dart';


class Utils {
  static final DateFormat dateFormat = DateFormat("yyyy-MM-dd hh:mm:ss");

  static showSnackBarMessage(BuildContext context, String message, bool isError) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : Colors.blue,
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  ///
  /// Password must contain one digit from 1 to 9,
  /// one lowercase letter, one uppercase letter,
  /// one special character (~`@#\$%^&*()-_+=), no space,
  /// and it must be at least 8 characters long.
  ///
  static bool isPasswordValid(String? password) {
    const String pwdRegEx = "(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[~@#%^&_+])";
    // final int minPwLength = 6;
    if (password == null || password.isEmpty || password.contains(' ')) {
      return false;
    }
    RegExp regex = RegExp(pwdRegEx);
    return regex.hasMatch(password);
    // return password.length < minPwLength;
  }

  ///
  /// Build and Show Dialog
  ///
  static Future<dynamic> buildShowDialog(
      BuildContext context,
      String title,
      String showText,
      bool isError) {

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        backgroundColor: isError ? Colors.red.shade200 : Colors.blueGrey,
        content: Text(
          showText,
        ),

        actions: [
          TextButton(
            child: const Text(
              'OK',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            onPressed: () => Navigator.pop(context, 'OK'),
          ),
        ],
      ),
    );
  }

  ///
  /// Build and Show Email Text Field Dialog
  ///
  static Future<dynamic> buildShowEmailTextFieldDialog(
      BuildContext context,
      TextEditingController textFieldController) async {

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(

        title: const Text("Enter Email Address"),

        content: TextField(
          controller: textFieldController,
        ),

        actions: <Widget> [
          TextButton(
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              onPressed: () {
                //textFieldController has the value
                if (textFieldController.text.isValidEmail()) {
                  Navigator.pop(context, 'OK');
                  return;
                }
                var result = buildShowDialog(
                    context, "Invalid Email", "The email: ${textFieldController.text} is invalid", true);

              }
          ),
          TextButton(
            child: const Text(
              'CANCEL',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),

            onPressed: () {
              Navigator.pop(context, 'CANCEL');
            },
          ),
        ],
      ),
    );
  }

  ///
  /// Build and Show Phone Text Field Dialog
  ///
  static Future<dynamic> buildShowPhoneTextFieldDialog(
      BuildContext context,
      String title,
      String errorTitle,
      Function validator,
      TextEditingController textFieldController) async {

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(

        title: Text(title),

        content: TextField(
          controller: textFieldController,
        ),

        actions: <Widget> [
          TextButton(
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              onPressed: () {
                //textFieldController has the value
                if (validator()) {
                  Navigator.pop(context, 'OK');
                  return;
                }
                var result = buildShowDialog(
                    context,
                    errorTitle,
                    "The value ${textFieldController.text} is invalid",
                    true);

              }
          ),
          TextButton(
            child: const Text(
              'CANCEL',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),

            onPressed: () {
              Navigator.pop(context, 'CANCEL');
            },
          ),
        ],
      ),
    );
  }


  ///
  /// Build and Show Confirmation Dialog
  ///
  static Future<dynamic> buildShowConfirmationDialog(
      BuildContext context,String title, String message) async {

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(

        title: Text(title),

        content: Text(message),

        actions: <Widget> [
          TextButton(
              child: const Text(
                'YES',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              onPressed: () {
                Navigator.pop(context, 'YES');
              }
          ),
          TextButton(
            child: const Text(
              'NO',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),

            onPressed: () {
              Navigator.pop(context, 'NO');
            },
          ),
        ],
      ),
    );
  }

  ///
  /// send data as an email
  ///
  static sendEmail(
      BuildContext context,
      String emailTo,
      String emailSubject,
      String emailBody
      // String emailCc,
      // String attachments
      )  async {

    final Email email = Email(
      subject: emailSubject,
      recipients: [emailTo],
      body: emailBody,
      // cc: [emailCc],
      // attachmentPaths: [attachments],
    );

    await FlutterEmailSender.send(email);
  }

  // static void createAndSendTextMessage(Game game, Player playerFrom, Player playerTo) async {
  static void createAndSendTextMessage(Player playerFrom, Player playerTo) async {
    String msg = "Tic Tac Toe Player:\n "
        "${playerFrom.name} has challenged you with a game."
        " After signing in, join game between \n"
        "${playerFrom.name} and  ${playerTo.name}";
    try {
      send_SMS2(msg, [playerTo.phoneNumber]);
      // send_SMS2(msg, ["281-433-0248"]);
    } catch (e) {
      print("SEND MESSAGE ERROR: $e");
    }
  }

  ///
  /// send SMS Text messages
  ///
  static void send_SMS(String msg, List<String> list_receipents) async {
    String send_result = await sendSMS(message: msg, recipients: list_receipents)
        .catchError((err) {
      print("SEND SMS MESSAGE ERROR: $err");
    });

    print(send_result);

  }

  ///
  /// send SMS Text messages
  ///
  static void send_SMS2(String msg, List<String> list_receipents) async {
    launchSmsMulti(message: msg, numbers: list_receipents);
    // String send_result = await sendSMS(message: msg, recipients: list_receipents)
    //     .catchError((err) {
    //   print("SEND SMS MESSAGE ERROR: $err");
    // });

    // print(send_result);

  }

}