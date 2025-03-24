import 'package:flutter/material.dart';

class SystemMessage extends StatelessWidget {
  const SystemMessage({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
   return Align(
    alignment: Alignment.center,
    child: Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 0.2),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(10), 
          bottomLeft: Radius.circular(10), 
          topLeft: Radius.circular(10), 
          topRight: Radius.circular(10),
        ),
      ),
      child: Text(text, style: TextStyle(fontSize: 18, color: Colors.white)),
    ),
   );
  }
}