import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onTap,
    this.carBrand,
    this.driverName,
    this.avatar,
  });
  final void Function()? onTap;
  final String? carBrand;
  final String? driverName;
  final String? avatar;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(10),
        width: double.infinity,
        height: MediaQuery.of(context).size.width * 0.175,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Color(0xFF0C1515)),
          borderRadius: BorderRadius.circular(35),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage:
                  avatar != null && avatar!.isNotEmpty
                      ? NetworkImage(avatar!) 
                      : const AssetImage('assets/default_avatar.png')
                          as ImageProvider,
              radius: 40,
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                Text(
                  '$carBrand',
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 215, 219, 218),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '$driverName',
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Color(0xffFAFFFE),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
