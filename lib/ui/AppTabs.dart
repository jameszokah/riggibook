import 'package:flutter/material.dart';

class AppTab extends StatelessWidget {
  final String? text;
  final Color? color;

  AppTab({@required this.text, @required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 90,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: this.color,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              blurRadius: 7,
              offset: Offset(0, 0),
              color: Colors.black.withOpacity(0.3),
            ),
          ],
        ),
        child: Text(this.text!,
            style: TextStyle(
              color: Colors.white,
            )));
  }
}
