import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memory_card_game_rune/model/card_image_name.dart';
import 'package:memory_card_game_rune/model/data_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memory_card_game_rune/model/image_data.dart';
import 'package:memory_card_game_rune/screen/home_screen.dart';
import 'package:memory_card_game_rune/widget/text_widget.dart';

class PlayScreen extends StatefulWidget {
  final int currentImageIndex;
  const PlayScreen({super.key, required this.currentImageIndex});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> with TickerProviderStateMixin {
  late List<String> imageDuplicated;
  late List<bool> flippedImages;
  List<int> flippedIndex = [];
  List<bool> matchedCards = [];
  bool isRunning = false;
  int cardCount = 6;
  bool isGridView = false;
  final cardImageName = CardImageName();

  late List<AnimationController> animationControllers;
  late List<Animation<double>> animations;
  late AnimationController _controller;
  bool _isGameComplete = false;
  late AnimationController _controllers;
  late Animation<double> _opacityAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      });
    _controllers = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _opacityAnimations = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _gameStart();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    animationControllers = List.generate(
      imageDuplicated.length,
      (index) => AnimationController(
        vsync: this,
        duration: Duration(seconds: 1 + Random().nextInt(2)),
      ),
    );

    animations = animationControllers.map((controller) {
      return Tween<double>(begin: -200, end: 0).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ));
    }).toList();

    for (var controller in animationControllers) {
      controller.forward();
    }
  }

  @override
  void dispose() {
    for (var controller in animationControllers) {
      controller.dispose();
    }
    _controllers.dispose();
    super.dispose();
  }

  void _showCompletionAnimation() {
    setState(() {
      _isGameComplete = true;
    });
    _controller.forward();

    Future.delayed(Duration(seconds: 3.2.toInt()), () {
      _controller.reset();
      setState(() {
        _isGameComplete = false;
      });
    });
  }

  void _gameStart() {
    List<String> images = ImageData.images;
    imageDuplicated = images.take(cardCount ~/ 2).toList();
    imageDuplicated = [...imageDuplicated, ...imageDuplicated];
    imageDuplicated.shuffle(Random());
    flippedImages = List.filled(imageDuplicated.length, false);
    matchedCards = List.filled(imageDuplicated.length, false);
    _initializeAnimations();
  }

  void _gameRefresh() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: TextWidget(
              text: "Confirm Action",
              color: Colors.black,
              fontsize: 23.sp,
              fontweight: false),
          content: TextWidget(
              text: "Are you sure you want to refresh the cards?",
              color: Colors.black,
              fontsize: 17.sp,
              fontweight: false),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: TextWidget(
                  text: "Cancel",
                  color: const Color(0xFF2b3990),
                  fontsize: 17.sp,
                  fontweight: false),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _gameStart();
                _initializeAnimations();
                setState(() {});
              },
              child: TextWidget(
                  text: "Confirm",
                  color: const Color(0xFF2b3990),
                  fontsize: 17.sp,
                  fontweight: false),
            ),
          ],
        );
      },
    );
  }

  void _onUpdateGameMode(int cardQuantity, int grid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: TextWidget(
              text: "Confirm Action",
              color: Colors.black,
              fontsize: 23.sp,
              fontweight: false),
          content: TextWidget(
              text:
                  "Are you sure you want to change to Game Mode with 3 x $grid Cards?",
              color: Colors.black,
              fontsize: 17.sp,
              fontweight: false),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: TextWidget(
                  text: "Close",
                  color: const Color(0xFF2b3990),
                  fontsize: 17.sp,
                  fontweight: false),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  cardCount = cardQuantity;
                  List<String> images = ImageData.images;
                  imageDuplicated = images.take(cardQuantity ~/ 2).toList();
                  imageDuplicated = [...imageDuplicated, ...imageDuplicated];
                  imageDuplicated.shuffle(Random());
                  flippedImages = List.filled(imageDuplicated.length, false);
                  matchedCards = List.filled(imageDuplicated.length, false);
                  _initializeAnimations();
                });
              },
              child: TextWidget(
                  text: "Confirm",
                  color: const Color(0xFF2b3990),
                  fontsize: 17.sp,
                  fontweight: false),
            ),
          ],
        );
      },
    );
  }

  void _onTapImage(int index) {
    if (flippedImages[index] || isRunning) return;

    setState(() {
      flippedImages[index] = true;
      flippedIndex.add(index);
    });

    if (flippedIndex.length == 2) {
      isRunning = true;
      if (imageDuplicated[flippedIndex[0]] ==
          imageDuplicated[flippedIndex[1]]) {
        Future.delayed(const Duration(milliseconds: 800), () {
          setState(() {
            imageDuplicated[flippedIndex[0]] = "";
            imageDuplicated[flippedIndex[1]] = "";
            flippedIndex.clear();
            isRunning = false;
          });
        });
        if (!flippedImages.contains(false)) {
          Future.delayed(const Duration(seconds: 1), () {
            _showCompletionAnimation();
          });
          Future.delayed(Duration(seconds: 4.toInt()), () {
            setState(() {
              _gameStart();
            });
          });
        }
      } else {
        Future.delayed(
          const Duration(seconds: 1),
          () {
            setState(() {
              flippedImages[flippedIndex[0]] = false;
              flippedImages[flippedIndex[1]] = false;
              flippedIndex.clear();
              isRunning = false;
            });
          },
        );
      }
    }
  }

  void _showGameInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: TextWidget(
              text: "Game Info",
              color: Colors.black,
              fontsize: 23.sp,
              fontweight: false),
          content: TextWidget(
              text:
                  "A fun and challenging game that tests your memory! Flip the cards to find matching pairs.",
              color: Colors.black,
              fontsize: 17.sp,
              fontweight: false),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: TextWidget(
                  text: "Close",
                  color: const Color(0xFF2b3990),
                  fontsize: 17.sp,
                  fontweight: false),
            ),
          ],
        );
      },
    );
  }

  void _updateConfirmShowCardHints() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: TextWidget(
                text: "Confirm Action",
                color: Colors.black,
                fontsize: 23.sp,
                fontweight: false),
            content: TextWidget(
                text:
                    "Are you sure you want to check the card hints? Note: All cards will be flipped back.",
                color: Colors.black,
                fontsize: 17.sp,
                fontweight: false),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: TextWidget(
                    text: "Cancel",
                    color: const Color(0xFF2b3990),
                    fontsize: 17.sp,
                    fontweight: false),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Future.delayed(const Duration(seconds: 1), () {
                    _showCardHints();
                  });
                },
                child: TextWidget(
                    text: "Confirm",
                    color: const Color(0xFF2b3990),
                    fontsize: 17.sp,
                    fontweight: false),
              ),
            ],
          );
        });
  }

  void _showCardHints() {
    setState(() {
      flippedImages = List.filled(imageDuplicated.length, true);
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        flippedImages = List.generate(
          imageDuplicated.length,
          (index) => matchedCards[index] || !flippedImages[index],
        );
      });
    });
  }

  void _toggleCardDesign() {
    setState(() {
      isGridView = !isGridView;
    });
  }

  void _showHowToPlayDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: TextWidget(
              text: "How to Used?",
              color: Colors.black,
              fontsize: 23.sp,
              fontweight: false),
          content: SizedBox(
            height: 200,
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: DataModel.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    DataModel.data[index]['text'],
                    style: GoogleFonts.russoOne(fontSize: 17.sp),
                  ),
                  trailing: Icon(
                    DataModel.data[index]['icon'],
                    size: 20.sp,
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: TextWidget(
                  text: "Close",
                  color: const Color(0xFF2b3990),
                  fontsize: 17.sp,
                  fontweight: false),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.width > 800 ? 100.0 : 56.0,
        ),
        child: AppBar(
          backgroundColor: const Color(0xFFede2b4),
          elevation: 0,
          title: Text(
            "Mystic MemoryGame",
            style: GoogleFonts.russoOne(
              fontSize: 23.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.6),
                  offset: const Offset(2, 2),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _gameRefresh,
            ),
            IconButton(
              icon: const Icon(Icons.lightbulb_outline),
              onPressed: _updateConfirmShowCardHints,
            ),
          ],
          iconTheme: IconThemeData(color: Colors.white, size: 25.sp),
        ),
      ),
      drawer: buildDrawer(),
      body: Stack(
        children: [
          buildBackground(),
          buildCard(),
          if (_isGameComplete) buildGameMessage()
        ],
      ),
    );
  }

  Widget buildBackground() {
    return Positioned.fill(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/backgroundImage1.jpg"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget buildGameMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _controllers,
            builder: (context, child) {
              return Opacity(
                opacity: _opacityAnimations.value,
                child: Icon(
                  Icons.emoji_events,
                  color: Colors.white,
                  size: 100.sp,
                ),
              );
            },
          ),
          SizedBox(height: 20.h),
          AnimatedBuilder(
            animation: _controllers,
            builder: (context, child) {
              return Opacity(
                opacity: _opacityAnimations.value,
                child: child,
              );
            },
            child: Text(
              "Mystic Victory Unlocked!",
              style: GoogleFonts.russoOne(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.6),
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _controllers,
            builder: (context, child) {
              return Opacity(
                opacity: _opacityAnimations.value,
                child: child,
              );
            },
            child: Image.asset(
              'assets/images/winimage.png',
              width: 300,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard() {
    const double radius = 170.0;
    final double angleIncrement = 2 * pi / imageDuplicated.length;

    return Center(
      child: isGridView
          ? GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cardCount == 6 ? 3 : 4,
              ),
              itemCount: imageDuplicated.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _onTapImage(index),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                    color: Colors.transparent,
                    child: AnimatedBuilder(
                      animation: animations[index],
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, animations[index].value),
                          child: child,
                        );
                      },
                      child: GestureDetector(
                        onTap: () => _onTapImage(index),
                        child: flippedImages[index]
                            ? (imageDuplicated[index].isNotEmpty
                                ? Image.asset(
                                    imageDuplicated[index],
                                    width: 100,
                                    height: 100,
                                  )
                                : Container())
                            : Image.asset(
                                cardImageName.images[widget.currentImageIndex]
                                    ['imageAsset'],
                                width: 100,
                                height: 100,
                              ),
                      ),
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Stack(
                children: List.generate(imageDuplicated.length, (index) {
                  final double angle = angleIncrement * index;
                  final double xOffset = radius * cos(angle);
                  final double yOffset = radius * sin(angle);
                  final double zIndex = (angle / (2 * pi)) * 100;

                  return Positioned(
                    left: MediaQuery.of(context).size.width / 2 + xOffset - 51,
                    top: MediaQuery.of(context).size.height / 2 + yOffset - 100,
                    child: AnimatedBuilder(
                      animation: animations[index],
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, animations[index].value),
                          child: child,
                        );
                      },
                      child: GestureDetector(
                        onTap: () => _onTapImage(index),
                        child: Transform(
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateZ(zIndex),
                          alignment: FractionalOffset.center,
                          child: flippedImages[index]
                              ? (imageDuplicated[index].isNotEmpty
                                  ? Image.asset(
                                      imageDuplicated[index],
                                      width: 100,
                                      height: 100,
                                    )
                                  : Container())
                              : Image.asset(
                                  cardImageName.images[widget.currentImageIndex]
                                      ['imageAsset'],
                                  width: 100,
                                  height: 100,
                                ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
    );
  }

  Widget buildDrawer() {
    final double largeScreen =
        MediaQuery.of(context).size.width > 800 ? 500 : 240;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double iconSize = screenWidth > 800 ? 15.sp : 23.sp;
    return SizedBox(
      width: largeScreen,
      child: Drawer(
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFFede2b4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome To Mystic MemoryGame",
                    style: GoogleFonts.russoOne(
                      fontSize: screenWidth > 800 ? 14.sp : 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          // ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.6),
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.white,
                              width: 1,
                            ),
                          ),
                          child: Image.asset(
                            cardImageName.images[widget.currentImageIndex]
                                ['imageAsset'],
                            width: screenWidth > 800 ? 50 : 40,
                            height: screenWidth > 800 ? 50 : 40,
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                          child: Text(
                            "Fate : ${cardImageName.images[widget.currentImageIndex]['cardName']}",
                            style: GoogleFonts.russoOne(
                              fontSize: screenWidth > 800 ? 20.sp : 18.sp,
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
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            ListTile(
              leading: Icon(
                Icons.details,
                size: iconSize,
              ),
              title: TextWidget(
                  text: "Game Info",
                  color: Colors.black,
                  fontsize: screenWidth > 800 ? 13.sp : 18.sp,
                  fontweight: false),
              trailing: Icon(
                Icons.chevron_right,
                size: iconSize,
              ),
              onTap: () {
                Navigator.of(context).pop();
                _showGameInfo();
              },
            ),
            SizedBox(
              height: 10.h,
            ),
            ListTile(
              leading: Icon(
                Icons.games_outlined,
                size: iconSize,
              ),
              title: TextWidget(
                  text: "How to Used?",
                  color: Colors.black,
                  fontsize: screenWidth > 800 ? 13.sp : 18.sp,
                  fontweight: false),
              trailing: Icon(
                Icons.chevron_right,
                size: iconSize,
              ),
              onTap: () {
                Navigator.of(context).pop();
                _showHowToPlayDialog();
              },
            ),
            SizedBox(
              height: 10.h,
            ),
            ListTile(
              leading: Icon(
                Icons.grid_3x3,
                size: iconSize,
              ),
              title: TextWidget(
                  text: "Game Mode 3 X 2",
                  color: Colors.black,
                  fontsize: screenWidth > 800 ? 13.sp : 18.sp,
                  fontweight: false),
              trailing: Icon(
                Icons.chevron_right,
                size: iconSize,
              ),
              onTap: () {
                Navigator.of(context).pop();
                _onUpdateGameMode(6, 2);
              },
            ),
            SizedBox(
              height: 10.h,
            ),
            ListTile(
              leading: Icon(
                Icons.grid_4x4,
                size: iconSize,
              ),
              title: TextWidget(
                  text: "Game Mode 3 X 4",
                  color: Colors.black,
                  fontsize: screenWidth > 800 ? 13.sp : 18.sp,
                  fontweight: false),
              trailing: Icon(
                Icons.chevron_right,
                size: iconSize,
              ),
              onTap: () {
                Navigator.of(context).pop();
                _onUpdateGameMode(12, 4);
              },
            ),
            SizedBox(
              height: 10.h,
            ),
            ListTile(
              leading: Icon(
                Icons.swipe,
                size: iconSize,
              ),
              title: TextWidget(
                  text:
                      "Switch to ${isGridView ? 'Circular' : 'Grid'} Card Design",
                  color: Colors.black,
                  fontsize: screenWidth > 800 ? 13.sp : 18.sp,
                  fontweight: false),
              trailing: Icon(
                Icons.chevron_right,
                size: iconSize,
              ),
              onTap: () {
                _toggleCardDesign();
                Navigator.of(context).pop();
              },
            ),
            SizedBox(
              height: 10.h,
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                size: iconSize,
              ),
              title: TextWidget(
                  text: "Quit Game",
                  color: Colors.black,
                  fontsize: screenWidth > 800 ? 13.sp : 18.sp,
                  fontweight: false),
              trailing: Icon(
                Icons.chevron_right,
                size: iconSize,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const HomeScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
