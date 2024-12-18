import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memory_card_game_rune/screen/demo_screen.dart';
import 'package:memory_card_game_rune/screen/home_screen.dart';
import 'package:memory_card_game_rune/http/api_service.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  String? url;

  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    fetchIsOn();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  Future<void> fetchIsOn() async {
    String? fetchedUrl = await _apiService.fetchIsOn();
    setState(() {
      url = fetchedUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0),
          ),
          child: child!,
        );
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: url == null
            ? Center(
                child: Container(
                  width: 150,
                  height: 150,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.asset("assets/images/logo.png"),
                ),
              )
            : url!.isEmpty
                ? const HomeScreen()
                : WebViewScreen(
                    backgroundColor: Colors.black,
                    url: url!,
                  ),
      ),
    );
  }
}
