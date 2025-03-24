import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:talker/src/pages/settings_page.dart';

class ActionBar extends StatelessWidget {
  const ActionBar({super.key, this.withBackButton = false});

  final bool withBackButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (withBackButton) InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Icon(Icons.chevron_left_sharp, color: Colors.white,),
                    Text("Voltar", style: TextStyle(fontSize: 18, color: Colors.white),)
                  ],
                ) 
              ),
              SizedBox(
                  height: 24,
                  width: 24,
                  child: SvgPicture.asset("assets/logo.svg"),
                ),
              if(withBackButton == false) InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
                },
                child: withBackButton == false ? Icon(Icons.settings, color: Colors.white,) : null,
              ),
            ],
          ),
        ),

        SizedBox(
          width: double.infinity,
          height: 1,
          child: Container(
            color: Color.fromRGBO(255, 255, 255, 0.4),
          ),
        )
      ],
    );
  }
}