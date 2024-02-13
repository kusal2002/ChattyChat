import 'package:flutter/material.dart';

class EmojisWidget extends StatefulWidget {
  final Function addEmojiToTextController;

  const EmojisWidget({
    super.key,
    required this.addEmojiToTextController,
  });

  @override
  State<EmojisWidget> createState() => _EmojisWidget();
}

class _EmojisWidget extends State<EmojisWidget>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 5,
        right: 5,
        bottom: 5,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            TabBar(
              controller: tabController,
              tabs: [
                Icon(Icons.emoji_emotions),
              ],
            )
          ],
        ),
      ),
    );
  }
}
