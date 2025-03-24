import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/web.dart';
import 'package:talker/src/pages/home_page.dart';
import 'package:talker/src/pages/login_page.dart';
import 'package:talker/src/services/firebase_database.dart';

class AuthServer{
  final _authInstance = FirebaseAuth.instance;
  var logger = Logger();

  void _goToPage(String page, BuildContext context){
    switch (page) {
      case "home":
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage())
        );
        break;
      case "login":
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => LoginPage())
        );
        break;
      default:
    }
  }

  Future<User?> isAuthenticated() async {
    User? userReturn;
    await _authInstance.authStateChanges().listen((User? user) {
      userReturn = user;
    });

    return userReturn;
  }

  User? getUser(){
    return _authInstance.currentUser;
  }

  Future<void> createUser(String name, String email, String password, BuildContext context) async {
    String messageError = "";
    try {
      await _authInstance.createUserWithEmailAndPassword(email: email, password: password);

      var user = await isAuthenticated();
 
      if(user != null){
        user.updateDisplayName(name);
      }

      await DatabaseFirebase().createUser(name, user?.email ?? "", user?.uid ?? "").then((_) {
        if(context.mounted){
          _goToPage("home", context);
        }
      });
    } on FirebaseAuthException catch(e){
      if(e.code == "weak-password"){
       messageError = 'Senha muito curta';
      }else if (e.code == 'email-already-in-use') {
        messageError = 'Usuário já existe.';
      }

      Fluttertoast.showToast(
        msg: messageError,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
      );
    } catch (e) {
      logger.w(e);
    }
  }

  Future<void> login(String email, String password, BuildContext context) async{
    String messageError = "";
    try {
      await _authInstance.signInWithEmailAndPassword(email: email, password: password);
      if(context.mounted){
        _goToPage("home", context);
      }
    } on FirebaseAuthException catch(e){
      if(e.code == "user-not-found"){
       messageError = 'Usuário ou senha incorreto';
      }else if (e.code == 'wrong-password') {
        messageError = 'Usuário ou senha incorreto.';
      }else{
        messageError = e.message.toString();
      }

      Fluttertoast.showToast(
        msg: messageError,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
      );
    } catch (e) {
      logger.w(e);
    }
  }

  Future<void> logout(BuildContext context) async{
    try {
      await _authInstance.signOut();
      if(context.mounted){
        _goToPage("login", context);
      }
    } catch (e) {
      logger.w(e);
    }
  }

  Future<void> updateUserSettings(String name) async{
    String messageError = "";
    try {
      var user = await isAuthenticated();
 
      if(user != null){
        user.updateDisplayName(name);
      }
    } on FirebaseAuthException catch(e){
      messageError = e.message.toString();

      Fluttertoast.showToast(
        msg: messageError,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
      );

    } catch (e) {
      logger.w(e);
    }
  }
}