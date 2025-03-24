import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:talker/src/services/auth.dart';
import 'package:talker/src/widgets/button_simple.dart';
import 'package:talker/src/widgets/input_text.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late User user;
  final usernameController = TextEditingController(text: "");
  final emailController = TextEditingController(text: "");
  bool loadingButton = false;

  void getUser() async {
    user = (await AuthServer().isAuthenticated())!;
    usernameController.text = user.displayName ?? "";
    emailController.text = user.email ?? "";
  }

  void saveUser() async{
    setState(() {
      loadingButton = true;
    });
    await AuthServer().updateUserSettings(usernameController.text).then((_){
      Future.delayed(Duration(milliseconds: 500), (){
        setState(() {
          loadingButton = false;
        });

      });
    });
  }

  @protected
  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(32, 33, 35, 1),
      body: SafeArea(child: 
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     SizedBox(
                      width: 90,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Row(
                            children: [
                              Icon(Icons.chevron_left_sharp, color: Colors.white,),
                              Text("Voltar", style: TextStyle(fontSize: 18, color: Colors.white),)
                            ],
                          ),
                        ),
                     ),
                      
                      SizedBox(
                        height: 40,
                      ),
                  
                      Column(children: [
                        InputText(inputController: usernameController, hintText: "Username", typeInput: TextInputType.name,
                          inputAction: TextInputAction.send, submitted: saveUser,
                        ),
                                          
                        SizedBox(
                          height: 20,
                        ),
                                          
                        InputText(inputController: emailController, hintText: "Email", isEnable: false),
                        
                        SizedBox(
                          height: 20,
                        ),
                                          
                        ButtonSimple(text: "Salvar", isLoading: loadingButton, onPressed: saveUser),

                        SizedBox(
                          height: 20,
                        ),
                      ],
                      ),
                  ],
                ), 
              ),
            ),
            
            SizedBox(
              width: double.infinity,
              height: 1,
              child: Container(
                color: Color.fromRGBO(255, 255, 255, 0.4),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child:  SizedBox(
                width: 120,
                child: InkWell(
                  onTap: () {
                    AuthServer().logout(context);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app_outlined, color: Colors.red,),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Logout", style: TextStyle(fontSize: 18, color: Colors.red),)
                    ],
                  ),
                ),
              ), 
            )
          ],
        ),
      ),
    );
  }
}