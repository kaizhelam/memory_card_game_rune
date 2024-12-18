import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;

  CustomAppBar({
    Key? key,
    required this.title,
    this.height = kToolbarHeight,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color(0xFFede2b4),
      elevation: 0,
      title: Text(
        title,
        style: GoogleFonts.russoOne(
          fontSize: 28.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          color: Colors.white,
          shadows: [
            Shadow(
              blurRadius: 10.0,
              color: Colors.black.withOpacity(0.6),
              offset: const Offset(2, 2),
            ),
          ],
        ),
      ),
      centerTitle: true,
    );
  }
}
