import 'package:flutter/material.dart';
import 'package:ev_logger/screens/login.dart';
import 'package:get/get.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          const Login(),
          transition: Transition.downToUp,
          duration: const Duration(milliseconds: 200),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(25),
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: const Color(0xff2c53b7)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              textAlign: TextAlign.center,
              'Login                        ',
              style: TextStyle(
                fontSize: 28,
                color: Color(0xff2c53b7),
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(Icons.arrow_forward_ios_outlined, color: Color(0xff2c53b7)),
          ],
        ),
      ),
    );
  }
}
