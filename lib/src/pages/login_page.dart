import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:talker/src/pages/register_page.dart';
import 'package:talker/src/services/auth.dart';
import 'package:talker/src/widgets/button_simple.dart';
import 'package:talker/src/widgets/input_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController(text: "");
  final passwordController = TextEditingController(text: "");
  bool loadingButton = false;
  String errorMessage = "";

  void validateLogin() async{
    if(emailController.text.isEmpty){
      errorMessage = "O Email deve ser preenchido!";
    }else if(passwordController.text.isEmpty){
      errorMessage = "A Senha deve ser preenchido!";
    }else{
      errorMessage = "";
    }

     if(errorMessage.isNotEmpty){
      Fluttertoast.showToast(msg: errorMessage);
      setState(() {
        loadingButton = false;
      });
      return;
    }

    await AuthServer().login(emailController.text, passwordController.text, context);

    setState(() {
      loadingButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(52, 53, 65, 1),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 80, horizontal: 16),
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
            
                  SizedBox(
                    height: 40,
                  ),
          
                    Text("Explore, conecte-se e inspire-se em conversas significativas!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
          
                  SizedBox(
                    height: 40,
                  ),
            
                  InputText(inputController: emailController, hintText: "Email", typeInput: TextInputType.emailAddress, isPassword: false),
                  
                  SizedBox(
                    height: 20,
                  ),
                  
                  InputText(inputController: passwordController, hintText: "Password", typeInput: TextInputType.text, 
                    isPassword: true, inputAction: TextInputAction.send, submitted: (){
                      setState(() {
                        loadingButton = true;
                      });
                      validateLogin();
                    },
                  ),
                  
                  SizedBox(
                    height: 20,
                  ),
          
                  ButtonSimple(text: "Entrar", isLoading: loadingButton, onPressed: (){
                    setState(() {
                      loadingButton = true;
                    });
                    validateLogin();
                  }),
          
                  SizedBox(
                    height: 40,
                  ),
          
                  SizedBox(
                    width: double.infinity,
                    height: 1,
                    child: (
                      Container(
                        color: Color.fromRGBO(255, 255, 255, 0.4),
                      )
                    ),
                  ),
          
                  SizedBox(
                    height: 20,
                  ),
          
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                    },
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      child: Center(
                        child: Text("Criar uma conta",
                          style: TextStyle(color: Color.fromRGBO(16, 163, 127, 1), fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}