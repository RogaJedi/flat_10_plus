import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flat_10plus/chat/chat_service.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserId;
  const ChatPage({
    super.key,
    required this.receiverUserEmail,
    required this.receiverUserId
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserId,
          _messageController.text,
      );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverUserEmail),),
      body: Column(
        children: [
          Expanded(
              child: _buildMessageList(),
          ),
          _buildMessageInput(),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildMessageList () {
    return StreamBuilder(
        stream: _chatService
            .getMessages(
            widget.receiverUserId,
            _firebaseAuth.currentUser!.uid,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("loading");
          }
          return ListView(
            children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList(),
          );
        }
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var alignment = (
        data['senderId'] == _firebaseAuth.currentUser!.uid
    ) ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment:
            (data['senderId'] == _firebaseAuth.currentUser!.uid)
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
          mainAxisAlignment:
            (data['senderId'] == _firebaseAuth.currentUser!.uid)
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF504BFF)),
                borderRadius: BorderRadius.circular(8),
                color:
                  (data['senderId'] == _firebaseAuth.currentUser!.uid)
                      ? const Color(0xFF504BFF)
                      : const Color(0xFFFFFFFF)
              ),
              child: Text(
                data['message'],
                style: TextStyle(
                  color: (data['senderId'] == _firebaseAuth.currentUser!.uid)
                      ? const Color(0xFFFFFFFF)
                      : const Color(0xFF504BFF),
                  fontSize: 17,
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }

  Widget _buildMessageInput() {
    return Row(
      children: [
        SizedBox(width: 10),
        Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Написать сообщение',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              controller: _messageController,
            )
        ),
        IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.arrow_circle_right,
              size: 40,
              color: Color(0xFF504BFF),
            ),
        ),
      ],
    );
  }

}