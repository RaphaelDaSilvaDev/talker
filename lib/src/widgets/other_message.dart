import 'package:flutter/material.dart';

class OtherMessage extends StatelessWidget {
  const OtherMessage({super.key, required this.text, required this.date, required this.username});

  final String text;
  final String date;
  final String username;

  @override
  Widget build(BuildContext context) {
   return Wrap(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.only(right: 50),
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.2),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10), 
              topLeft: Radius.circular(10), 
              topRight: Radius.circular(10),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(username, style: TextStyle(color: Color.fromRGBO(16, 163, 127, 1), fontSize: 16, fontWeight: FontWeight.w600),),
                  SizedBox(height: 8),
                  Text(text, style: TextStyle(fontSize: 18, color: Colors.white)),
                ]
              ),
              Text(date, style: TextStyle(color: Color.fromRGBO(32, 33, 35, 1))),
            ],
          ),
        ),
      ],
    );
  }
}