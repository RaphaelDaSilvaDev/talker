import 'package:flutter/material.dart';

class InputMessage extends StatefulWidget {
  const InputMessage({super.key, required this.inputController, required this.hintText, 
  this.submitted, this.isLoading = false});

  final TextEditingController inputController;
  final String hintText;
  final VoidCallback? submitted;
  final bool isLoading;

  @override
  State<InputMessage> createState() => _InputMessageState();
}

class _InputMessageState extends State<InputMessage> {
  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(blurRadius: 0, offset: Offset(0, 0), spreadRadius: 6, color: Color.fromRGBO(255, 255, 255, 0.1))
                ],
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 6,
                minLines: 1,
                textInputAction: TextInputAction.newline,
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
                  fillColor: Color.fromRGBO(255, 255, 255, 0.1),
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  hintText: widget.hintText,
                  hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,color: Colors.white),
                controller: widget.inputController,
              ),
                    ),
          ),

          SizedBox(
            width: 16,
          ),

          InkWell(
            onTap: widget.isLoading ? null : widget.submitted,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: widget.isLoading ? Color.fromRGBO(16, 163, 127, 0.6) : Color.fromRGBO(16, 163, 127, 1),
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: widget.isLoading 
              ? CircularProgressIndicator(
                padding: EdgeInsets.all(16),
                color: Colors.white,
              )
              : Icon(Icons.send, color: Colors.white,),
            ),
          )
      ],
    );
  }
}