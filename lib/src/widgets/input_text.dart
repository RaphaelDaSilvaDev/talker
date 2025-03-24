import 'package:flutter/material.dart';

class InputText extends StatefulWidget {
  const InputText({super.key, required this.inputController, 
                    required this.hintText, 
                    this.typeInput = TextInputType.text,  
                    this.isPassword = false, 
                    this.inputAction = TextInputAction.next, 
                    this.submitted, 
                    this.isEnable = true,
    });

  final TextEditingController inputController;
  final String hintText;
  final TextInputType typeInput;
  final TextInputAction? inputAction;
  final bool? isPassword;
  final bool? isEnable;
  final VoidCallback? submitted;

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  var isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(blurRadius: 0, offset: Offset(0, 0), spreadRadius: 6, color: Color.fromRGBO(255, 255, 255, 0.1))
            ],
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          child: TextFormField(
            enabled: widget.isEnable,
            obscureText: widget.isPassword! ? isObscure : false,
            keyboardType: widget.typeInput,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Color.fromRGBO(16, 163, 127, 0.8),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Color.fromRGBO(255, 255, 255, 0.8),
                ),
              ),
              fillColor: widget.isEnable == true ? Color.fromRGBO(255, 255, 255, 0.1) : Color.fromRGBO(255, 255, 255, 0.05),
              filled: true,
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              hintText: widget.hintText,
              hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
              suffixIcon: widget.isPassword! ? GestureDetector(
                onTap: (){
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
                child: Icon(
                  isObscure ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white,
                ),
              ) : null
            ),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,color: Colors.white),
            controller: widget.inputController,
            textInputAction: widget.inputAction,
            onFieldSubmitted: (value) {
              if(widget.inputAction == TextInputAction.send){
                  widget.submitted!();
              }
            },
          ),
      );
  }
}