import 'package:flutter/material.dart';

class ButtonBlue extends StatelessWidget {
  final String text;
  final Function onTap;

  ButtonBlue({@required this.onTap, @required this.text});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 2,
      highlightElevation: 5,
      color: Colors.blue.shade700,
      shape: StadiumBorder(),
      onPressed: onTap,
      child: Container(
        width: double.infinity,
        height: 55,
        child: Center(
          child: Text('Ingrese', style: TextStyle(color: Colors.white, fontSize: 17),),
        ),
      ),
    );
  }
}
