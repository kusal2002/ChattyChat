import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:chatychat/services/chat/emoji_service.dart';

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
  EmojiService emojiisServices = EmojiService();
  List<Emoji> smileyEmojis = [];
  List<Emoji> petsEmojis = [];
  List<Emoji> foodsEmojis = [];
  List<Emoji> sportsEmojis = [];
  List<Emoji> vehiclesEmojis = [];
  List<Emoji> toolsEmojis = [];
  List<Emoji> objectsEmojis = [];
  List<Emoji> flagsEmojis = [];
  @override
  void initState() {
    tabController = TabController(length: 8, vsync: this);
    for (var emojiSet in defaultEmojiSet) {
      emojiisServices.getCategoryEmojis(category: emojiSet).then(
            (e) async =>
                await emojiisServices.fillterUnsupported(data: [e]).then(
              (filtered) {
                for (var element in filtered) {
                  switch (emojiSet.category) {
                    case Category.SMILEYS:
                      setState(() {
                        smileyEmojis = element.emoji;
                      });
                      break;
                    case Category.SMILEYS:
                      setState(() {
                        smileyEmojis = element.emoji;
                      });
                      break;
                    case Category.ANIMALS:
                      setState(() {
                        petsEmojis = element.emoji;
                      });
                      break;
                    case Category.FOODS:
                      setState(() {
                        foodsEmojis = element.emoji;
                      });
                      break;
                    case Category.ACTIVITIES:
                      setState(() {
                        sportsEmojis = element.emoji;
                      });
                      break;
                    case Category.TRAVEL:
                      setState(() {
                        toolsEmojis = element.emoji;
                      });
                      break;
                    case Category.SYMBOLS:
                      setState(() {
                        toolsEmojis = element.emoji;
                      });
                      break;
                    case Category.OBJECTS:
                      setState(() {
                        objectsEmojis = element.emoji;
                      });
                      break;
                    case Category.FLAGS:
                      setState(() {
                        flagsEmojis = element.emoji;
                      });
                      break;
                    default:
                  }
                }
              },
            ),
          );
    }
    super.initState();
  }

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
              isScrollable: false,
              labelColor: Colors.blue,
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(color: Colors.blue, width: 3),
                insets: EdgeInsets.symmetric(horizontal: 3),
              ),
              indicatorSize: TabBarIndicatorSize.label,
              labelPadding: const EdgeInsets.all(5),
              unselectedLabelColor: Colors.black.withOpacity(0.4),
              tabs: const [
                Icon(Icons.emoji_emotions),
                Icon(Ionicons.paw),
                Icon(Ionicons.fast_food),
                Icon(Ionicons.football),
                Icon(Ionicons.boat),
                Icon(Ionicons.bulb),
                Icon(Icons.emoji_symbols_rounded),
                Icon(Ionicons.flag),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  buildEmojis(emojis: smileyEmojis),
                  buildEmojis(emojis: petsEmojis),
                  buildEmojis(emojis: foodsEmojis),
                  buildEmojis(emojis: sportsEmojis),
                  buildEmojis(emojis: vehiclesEmojis),
                  buildEmojis(emojis: objectsEmojis),
                  buildEmojis(emojis: toolsEmojis),
                  buildEmojis(emojis: flagsEmojis),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildEmojis({required List<Emoji> emojis}) {
    return emojis.isEmpty
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : GridView.builder(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            itemCount: emojis.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8),
            itemBuilder: (context, index) {
              Emoji emoji = emojis[index];
              return Center(
                child: GestureDetector(
                  onTap: () {
                    widget.addEmojiToTextController(emoji: emoji);
                  },
                  child: Text(
                    emoji.emoji,
                    style: TextStyle(color: Colors.black, fontSize: 32),
                  ),
                ),
              );
            },
          );
  }
}
