import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showAlert(BuildContext context, String title, String subtitle) {
  return Platform.isIOS
      ? showCupertinoDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
                title: Text(title),
                content: Text(subtitle),
                actions: [
                  CupertinoButton(
                    child: Text('Ok'),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ))
      : showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(title),
            content: Text(subtitle),
            actions: [
              MaterialButton(
                child: Text('Ok'),
                elevation: 5,
                textColor: Colors.blue,
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        );
}
