import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memory_card_game_rune/model/card_image_name.dart';
import 'package:memory_card_game_rune/screen/play_screen.dart';
import 'package:memory_card_game_rune/widget/animated_button.dart';
import 'package:memory_card_game_rune/widget/story_dialog.dart';

class MenuWidget extends StatefulWidget {
  const MenuWidget({super.key});

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  final cardImageName = CardImageName();
  int _currentIndex = 0;
  bool _isFading = false;

  void _nextImage() {
    setState(() {
      _isFading = true;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _currentIndex = (_currentIndex + 1) % cardImageName.images.length;
        _isFading = false;
      });
    });
  }

  void _previousImage() {
    setState(() {
      _isFading = true;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _currentIndex = (_currentIndex - 1 + cardImageName.images.length) %
            cardImageName.images.length;
        _isFading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Ready for the challenge?",
            style: GoogleFonts.russoOne(
              fontSize: 25.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              // ignore: deprecated_member_use
              color: Colors.white.withOpacity(0.8),
              shadows: [
                Shadow(
                  blurRadius: 6.0,
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(1, 1),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "Choose Your Fate",
            style: GoogleFonts.russoOne(
              fontSize: 25.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              // ignore: deprecated_member_use
              color: Colors.white.withOpacity(0.8),
              shadows: [
                Shadow(
                  blurRadius: 6.0,
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(1, 1),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _previousImage,
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 40.sp,
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _isFading ? 0.0 : 1.0,
                child: Center(
                  child: Image.asset(
                    cardImageName.images[_currentIndex]['imageAsset'],
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              IconButton(
                onPressed: _nextImage,
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 40.sp,
                ),
              ),
            ],
          ),
          Text(
            cardImageName.images[_currentIndex]['cardName'],
            style: GoogleFonts.russoOne(
              fontSize: 25.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              // ignore: deprecated_member_use
              color: Colors.white.withOpacity(0.8),
              shadows: [
                Shadow(
                  blurRadius: 6.0,
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(1, 1),
                ),
              ],
            ),
          ),
          SizedBox(height: 30.h),
          AnimatedButton(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(
                      seconds: 1),
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return PlayScreen(
                      currentImageIndex: _currentIndex,
                    );
                  },
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = 0.95; 
                    const end = 1.0; 
                    const curve =
                        Curves.easeInOut; 

                    var zoomTween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var zoomAnimation = animation.drive(zoomTween);
                    return ScaleTransition(
                      scale: zoomAnimation,
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    );
                  },
                ),
              );
            },
            label: "Unlock the Magic!",
          ),
          SizedBox(
            height: 15.h,
          ),
          AnimatedButton(
            onPressed: () {
              showDialog(
                  context: context, builder: (context) => const StoryDialog());
            },
            label: "Story Mode",
          ),
        ],
      ),
    );
  }
}
