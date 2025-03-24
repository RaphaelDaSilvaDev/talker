import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:talker/src/services/auth.dart';
import 'package:talker/src/widgets/button_simple.dart';
import 'package:talker/src/widgets/input_text.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController(text: "");
  final emailController = TextEditingController(text: "");
  final passwordController = TextEditingController(text: "");
  final confirmPasswordController = TextEditingController(text: "");
  bool loadingButton = false;
  String errorMessage = "";

  void validateData() async {
    if(usernameController.text.isEmpty){
      errorMessage = "O Usuário deve ser preenchido!";
    }else if(emailController.text.isEmpty){
      errorMessage = "O Email deve ser preenchido!";
    }else if(passwordController.text.isEmpty){
      errorMessage = "A Senha deve ser preenchido!";
    }else if(confirmPasswordController.text.isEmpty){
      errorMessage = "A Confirmação da Senha deve ser preenchido!";
    }else if(confirmPasswordController.text != passwordController.text){
      errorMessage = "As Senhas devem ser iguais!";
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

    await AuthServer().createUser(usernameController.text, emailController.text, passwordController.text, context,);

    setState(() {
      loadingButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(52, 53, 65, 1),
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
          
                    Text("Crie sua conta e explore, conecte-se e inspire-se em conversas significativas!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
          
                  SizedBox(
                    height: 40,
                  ),
            
                  InputText(inputController: usernameController, hintText: "Username", typeInput: TextInputType.text, isPassword: false),
          
                  SizedBox(
                    height: 20,
                  ),
            
                  InputText(inputController: emailController, hintText: "Email", typeInput: TextInputType.emailAddress, isPassword: false),
                  
                  SizedBox(
                    height: 20,
                  ),
                  
                  InputText(inputController: passwordController, hintText: "Password", typeInput: TextInputType.text, isPassword: true,),
                  
                  SizedBox(
                    height: 20,
                  ),
                  
                  InputText(inputController: confirmPasswordController, hintText: "Confirm Password", typeInput: TextInputType.text,
                   isPassword: true, inputAction: TextInputAction.send, submitted: (){
                    setState(() {
                      loadingButton = true;
                    });
                    validateData();
                   },),
          
                  SizedBox(
                    height: 20,
                  ),
          
                  ButtonSimple(text: "Criar conta", isLoading: loadingButton, onPressed: (){
                    setState(() {
                      loadingButton = true;
                    });
                    validateData();
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
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      child: Center(
                        child: Text("Já tenho uma conta",
                          style: TextStyle(color: Color.fromRGBO(16, 163, 127, 1), fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}