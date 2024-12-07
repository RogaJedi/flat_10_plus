import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flat_10plus/auth/auth_service.dart';
import 'package:flat_10plus/pages/orders_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../chat/chat_service.dart';
import '../../widgets/confirmation_dialog.dart';
import 'chat_page.dart';


class ProfilePage extends StatefulWidget {
  final String userEmail;

  const ProfilePage({Key? key, required this.userEmail}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;



  void signOut() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
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
              Text(
                widget.userEmail,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context, MaterialPageRoute(
                      builder: (context) => const OrdersPage(),
                    ),
                    );
                  },
                  child: const Text("Ваши заказы")
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(
                      receiverUserEmail: 'seller@user.test',
                      receiverUserId: '3xYcUDkWZzOLjr6fUAfmyzCfVl22',
                    )));
                  },
                  child: const Text("Чат с продавцом")
              ),
            ],
          )
      ),
    );
  }
}