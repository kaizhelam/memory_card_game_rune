import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/images/backgroundImage1.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              // ignore: deprecated_member_use
              Colors.black.withOpacity(0.5),
              BlendMode.darken,
            ),
          ),
        ),
      ),
    );
  }
}
