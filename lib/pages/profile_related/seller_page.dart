import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flat_10plus/auth/auth_service.dart';
import 'package:flat_10plus/widgets/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../chat/chat_service.dart';
import 'chat_page.dart';

class SellerPage extends StatefulWidget {
  const SellerPage({Key? key}) : super(key: key);

  @override
  _SellerPageState createState() => _SellerPageState();
}

class _SellerPageState extends State<SellerPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;



  void signOut() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль продавца'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => ConfirmationDialog(
                  onConfirm: () {
                    signOut();
                    Navigator.of(context).pop();
                  },
                  thingToConfirmText: "Выйти из аккаунта",
                ),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                "Вы вошли в аккаунт!",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Чаты с пользователями:",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                  width: 250,
                  height: 300,
                  child: _buildUsersList()
              ),
            ],
          )
      ),
    );
  }

  Widget _buildUsersList() {
    final chatService = Provider.of<ChatService>(context, listen: false);

    return StreamBuilder<DocumentSnapshot>(
        stream: chatService.getUsersWithConversations(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("loading");
          }
          if (snapshot.hasData && snapshot.data!.exists) {
            Map<String, dynamic> conversations = snapshot.data!.data() as Map<String, dynamic>;
            return FutureBuilder<List<DocumentSnapshot>>(
              future: chatService.getUsersFromConversations(conversations.keys.toList()),
              builder: (context, usersSnapshot) {
                if (usersSnapshot.connectionState == ConnectionState.waiting) {
                  return const Text("loading users");
                }
                if (usersSnapshot.hasData) {
                  return ListView(
                    children: usersSnapshot.data!.map((doc) => _buildUsersListItem(doc)).toList(),
                  );
                }
                return Container();
              },
            );
          }
          return Container();
        }
    );
  }

  Widget _buildUsersListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    // Check if the current user's email is different from the document's email
    if (_auth.currentUser!.email != data['email']) {
      return ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade200,
          child: Text(
            data['email'][0].toUpperCase(),
            style: TextStyle(color: Colors.blue.shade800),
          ),
        ),
        title: Text(data['email']),
        trailing: Icon(Icons.chat_bubble_outline),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatPage(
                    receiverUserEmail: data['email'],
                    receiverUserId: data['uid'],
                  )
              )
          );
        },
      );
    } else {
      // Return an empty container for the current user
      return Container();
    }
  }
}