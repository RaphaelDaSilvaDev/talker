import 'package:flutter/material.dart';

class MyMessage extends StatelessWidget {
  const MyMessage({super.key, required this.text, required this.date});

  final String text;
  final String date;

  @override
  Widget build(BuildContext context) {
   return Wrap(
      alignment: WrapAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.only(left: 50),
          decoration: BoxDecoration(
            color:  Color.fromRGBO(16, 163, 127, 1),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10), 
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