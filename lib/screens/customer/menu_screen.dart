import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  Future<void> placeOrder() async {
    final user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance.collection('orders').add({
      'userId': user!.uid,
      'item': 'Burger',
      'price': 10,
      'status': 'placed',
      'createdAt': Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Menu")),
      body: Column(
        children: [
          const ListTile(
            title: Text("Burger - \$10"),
          ),
          ElevatedButton(
            onPressed: () async {
              await placeOrder();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Order placed!")),
              );
            },
            child: const Text("Order Burger"),
          ),
        ],
      ),
    );
  }
}