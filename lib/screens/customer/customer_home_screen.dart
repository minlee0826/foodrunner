import 'package:flutter/material.dart';
import 'menu_screen.dart';

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Restaurants")),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Pizza Shop"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MenuScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}