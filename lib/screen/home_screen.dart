import 'package:flutter/material.dart';
import 'package:memory_card_game_rune/widget/background_widget.dart';
import 'package:memory_card_game_rune/widget/custom_appbar.dart';
import 'package:memory_card_game_rune/widget/menu_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.width > 800 ? 100.0 : 56.0,
        ),
        child: CustomAppBar(
          title: "Mystic MemoryGame",
        ),
      ),
      body: const Stack(
        children: [BackgroundWidget(), MenuWidget()],
      ),
    );
  }
}
