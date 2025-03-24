import 'package:flutter/material.dart';

class TalkerChat extends StatelessWidget {
  const TalkerChat({super.key, 
  this.title = "", 
  this.answer = "", 
  this.date = "",
  this.onTapFunction, 
  required this.tag});

  final String title;
  final List<String> tag;
  final String answer;
  final String date;
  final VoidCallback? onTapFunction;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromRGBO(255, 255, 255, 0.1),
      elevation: 0,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: InkWell(
        onTap: onTapFunction,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        splashColor: Color.fromRGBO(16, 163, 127, 0.5),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 18, color: Colors.white),),
                  Text(tag.toString(), style: TextStyle(fontSize: 14, color: Color.fromRGBO(16, 163, 127, 1)),)
                ],
              ),
              Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(answer, style: TextStyle(fontSize: 14, color: Color.fromRGBO(16, 163, 127, 1)),),
                Text(date, style: TextStyle(fontSize: 14, color: Color.fromRGBO(16, 163, 127, 1)),)
              ],
            )
            ],
          ),
        ),
      ),
    );
  }
}