import 'package:flat_10plus/auth/auth_service.dart';
import 'package:flat_10plus/pages/orders_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {



  void signOut() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }




  @override
  Widget build(BuildContext context) {

    final userId = 'userid';
    final userEmail = 'useremail';

    //final userId = authService.getUserId();
    //final userEmail = authService.getUserEmail();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Вы вошли в аккаунт!",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "ID:$userId",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Email:$userEmail",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
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
                  onPressed: () {},
                  child: const Text("Чат с продавцом")
              ),
              const SizedBox(height: 60),
            ],
          )
      ),
    );
  }
}