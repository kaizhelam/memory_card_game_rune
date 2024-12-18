import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memory_card_game_rune/widget/text_widget.dart';

class StoryDialog extends StatefulWidget {
  const StoryDialog({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StoryDialogState createState() => _StoryDialogState();
}

class _StoryDialogState extends State<StoryDialog> {
  int currentPage = 1;

  final List<String> storyPages = [
   "Story 1: In a forgotten corner of the world, an old relic rests in the ruins of an ancient temple. Legends say that only those with the sharpest memory can uncover its secrets. To find it, you must unlock the mystery hidden within the cards. Each card reveals a piece of the story, but only those who remember the right matches will unravel the tale.",
    "Story 2: As the game begins, the cards are shuffled, and a mysterious voice echoes: 'Match the symbols, and the relic will reveal itself.' The cards seem simple at first glance, but each one holds an ancient symbol—each connected to a clue leading to the treasure. However, there’s a catch: matching the wrong symbols will lead you further away from the truth.",
    "Story 3: With each successful match, the story unravels. You learn about the temple's history, the guardian who protected the relic, and the betrayal that led to its hiding. But the final clue remains elusive. Only by matching the last two cards in the sequence will you reveal the location of the lost relic, hidden deep within the temple’s darkest corner.",
  ];

  void changePage(int pageNumber) {
    setState(() {
      currentPage = pageNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: TextWidget(
          text: "Mystery Story",
          color: Colors.black,
          fontsize: 23.sp,
          fontweight: false),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextWidget(
              text: (storyPages[currentPage - 1]),
              color: Colors.black,
              fontsize: 17.sp,
              fontweight: false),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              int pageNumber = index + 1;
              return GestureDetector(
                onTap: () => changePage(pageNumber),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: currentPage == pageNumber
                        ? const Color(0xFF2b3990)
                        : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: TextWidget(
                    text: pageNumber.toString(),
                    color:
                        currentPage == pageNumber ? Colors.white : Colors.black,
                    fontsize: 17.sp,
                    fontweight: false,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: TextWidget(
              text: "Close",
              color: const Color(0xFF2b3990),
              fontsize: 17.sp,
              fontweight: false),
        ),
      ],
    );
  }
}
