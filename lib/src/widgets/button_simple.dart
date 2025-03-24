import 'package:flutter/material.dart';

class ButtonSimple extends StatelessWidget {
  const ButtonSimple({super.
  key, required this.text, required this.onPressed, this.isLoading = false});

  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 48)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
          ) 
        ),
        backgroundColor: isLoading ? const WidgetStatePropertyAll(Color.fromRGBO(16, 163, 127, 0.6)) : const WidgetStatePropertyAll(Color.fromRGBO(16, 163, 127, 1))
      ),
      child: 
      isLoading 
      ? SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      )
      : Text(
          text,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
    );
  }
}