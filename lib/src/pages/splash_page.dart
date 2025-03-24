import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:talker/src/pages/home_page.dart';
import 'package:talker/src/pages/login_page.dart';
import 'package:talker/src/services/auth.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  
  void verifyUserIsLogged() async {
    User? user = await AuthServer().isAuthenticated();

    Future.delayed(Duration(seconds: 2), (){
        sendToPage(user);
    });
  }

Future<void> requestNotificationPermission() async {
  final status = await Permission.notification.request();
    if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  void sendToPage(User? user){
    if(user != null){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }
  
  @protected
  @override
  void initState(){
    super.initState();
    requestNotificationPermission();
    verifyUserIsLogged();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(52, 53, 65, 1),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/logo.svg", height: 96, width: 96),

              SizedBox(
                height: 40,
              ),
              
              Text("Talker",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
