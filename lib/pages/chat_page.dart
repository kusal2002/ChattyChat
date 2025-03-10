import 'package:chatychat/components/chat_bubble.dart';
import 'package:chatychat/components/emoji_picker.dart';
import 'package:chatychat/components/my_textfield.dart';
import 'package:chatychat/services/auth/auth_service.dart';
import 'package:chatychat/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //text controller
  final TextEditingController _messageController = TextEditingController();

  //chat & auth services
  final chatService _chatService = chatService();
  final AuthService _authService = AuthService();

  //for textfeild focus
  FocusNode myFocusNode = FocusNode();

  bool emojiShowing = false;
  @override
  void initState() {
    super.initState();

    //add listner to focus node
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        //cause a delay so that the keyboard has time to show up
        //then the amount of reamining space will be calculated,
        //then scroll down
        Future.delayed(const Duration(milliseconds: 500), () {
          scrollDown();
        });
      }
    });

//wait a bit for listview to be built , then scroll o the bottom
    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  //scroll contoller
  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
  }

//send message
  void sendMessage() async {
    //if there is something inside the textfield
    if (_messageController.text.isNotEmpty) {
      //send the message
      await _chatService.sendMessage(
          widget.receiverID, _messageController.text);

      //clear text controller
      _messageController.clear();
    }

    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Column(
        children: [
          //display all messagtes
          Expanded(
            child: _buildMessageList(),
          ),

          //user input
          _buildUserInput(),
        ],
      ),
    );
  }

//build message list
  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        //errors
        if (snapshot.hasError) {
          return const Text("Error");
        }

        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading..");
        }

        //return list view
        return ListView(
          controller: _scrollController,
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    //is current user
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    //align message to the right if sender is the current user , otherwiseleft
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(message: data["message"], isCurrentUser: isCurrentUser)
        ],
      ),
    );
  }
  //build message input
//   Widget _buildUserInput() {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 50.0),
//       child: Row(
//         children: [
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 10),
//             child: IconButton(
//               onPressed: () {},
//               icon: const Icon(
//                 Icons.emoji_emotions,
//                 color: Colors.grey,
//                 size: 25,
//               ),
//             ),
//           ),
//           //textfeild should take up most of the space
//           Expanded(
//             child: MyTextFeild(
//               hintText: "Type a message",
//               obscureText: false,
//               controller: _messageController,
//               focusNode: myFocusNode,
//             ),
//           ),

//           //sende button
//           Container(
//             decoration: const BoxDecoration(
//               color: Colors.green,
//               shape: BoxShape.circle,
//             ),
//             margin: const EdgeInsets.only(right: 25),
//             child: IconButton(
//               onPressed: sendMessage,
//               icon: const Icon(
//                 Icons.arrow_upward,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

  Widget _buildUserInput() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (emojiShowing)
          EmojisWidget(addEmojiToTextController: addEmojiToTextController),
        TextField(
          controller: _messageController,
          focusNode: myFocusNode,
          onTap: () {
            setState(() {
              emojiShowing = false;
            });
          },
          decoration: InputDecoration(
            prefixIcon: GestureDetector(
              onTap: () async {
                if (emojiShowing) {
                  setState(
                    () {
                      emojiShowing = false;
                    },
                  );
                  await Future.delayed(const Duration(milliseconds: 500)).then(
                    (value) async {
                      await SystemChannels.textInput
                          .invokeMethod("TextInput.show");
                    },
                  );
                } else {
                  await SystemChannels.textInput.invokeMethod("TextInputhide");
                  setState(() {
                    emojiShowing = true;
                  });
                }
                ;
              },
              child: Icon(
                emojiShowing ? Icons.keyboard : Icons.emoji_emotions_rounded,
                color: Colors.blue,
              ),
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  emojiShowing = false;
                });
                sendMessage();
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                margin: const EdgeInsets.only(right: 5),
                child: const Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                ),
              ),
            ),
            hintText: "Message",
          ),
        ),
      ],
    );
  }

  addEmojiToTextController({required Emoji emoji}) {
    setState(() {
      _messageController.text = _messageController.text + emoji.emoji;

      _messageController.selection = TextSelection.fromPosition(
          TextPosition(offset: _messageController.text.length));
    });
  }
}
