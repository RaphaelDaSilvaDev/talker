import 'package:flutter/material.dart';

class InputSearch extends StatefulWidget {
  const InputSearch({super.key, required this.inputController, required this.hintText, this.submitted});

  final TextEditingController inputController;
  final String hintText;
  final VoidCallback? submitted;

  @override
  State<InputSearch> createState() => _InputSearchState();
}

class _InputSearchState extends State<InputSearch> {
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
            keyboardType: TextInputType.text,
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
              suffixIcon: GestureDetector(
                onTap: (){},
                child: Icon(
                  Icons.search_rounded,
                  color: Colors.white,
                ),
              )
            ),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,color: Colors.white),
            controller: widget.inputController,
            onFieldSubmitted: (value) {},
          ),
      );
  }
}