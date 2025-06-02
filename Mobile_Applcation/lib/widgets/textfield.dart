import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyTextField extends StatelessWidget {
  MyTextField({
    super.key,
    required this.text,
    this.icon,
    this.suffixIcon,
    required this.obscure,
    required this.val,
    required this.mycontroller,
    required this.validator,
  });

  final String text;
  final bool obscure;
  final IconData? icon;
  final IconData? suffixIcon;
  final String val;
  final TextEditingController mycontroller;
  final String? Function(String?) validator;

  GlobalKey<FormState> formstate = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.3),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF01D5A2).withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Form(
          key: formstate,
          child: TextFormField(
            controller: mycontroller,
            validator: validator,
            style: const TextStyle(
              color: Colors.white,
            ), // Set input text color to white
            decoration: InputDecoration(
              hintText: text,
              hintStyle: const TextStyle(
                color: Colors.white,
              ), // Light white hint text
              prefixIcon:
                  icon != null
                      ? Icon(
                        icon,
                        color: const Color(0xFF01D5A2).withOpacity(0.4),
                      )
                      : null,
              suffixIcon:
                  suffixIcon != null
                      ? Icon(suffixIcon, color: Colors.white)
                      : null,
              labelText: text,
              labelStyle: const TextStyle(
                color: Colors.white,
              ), // Set label text color to white
              filled: true,
              fillColor: Colors.black.withOpacity(1),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
