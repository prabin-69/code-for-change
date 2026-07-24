import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String userName;
  const ChatScreen({
    super.key,
    required this.userName,
  });

  @override
  State<ChatScreen> createState() =>
      _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller =
      TextEditingController();
  final List<String> messages = [];

  void sendMessage(){
    if(controller.text.trim().isEmpty) {
      return;
    }
    setState(() {
      messages.add(controller.text);
      controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        Text(widget.userName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount:
              messages.length,
              itemBuilder:(context,index){
                return Align(
                  alignment:
                  Alignment.centerRight,
                  child: Container(
                    margin:
                    const EdgeInsets.all(8),
                    padding:
                    const EdgeInsets.all(12),
                    decoration:
                    BoxDecoration(
                      color:
                      Colors.blue,
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                    child:
                    Text(
                      messages[index],
                      style:
                      const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller:
                    controller,
                    decoration:
                    const InputDecoration(
                      hintText:
                      "Type message",
                    ),
                  ),
                ),
                IconButton(
                  icon:
                  const Icon(Icons.send),
                  onPressed:
                  sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}