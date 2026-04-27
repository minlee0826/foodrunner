import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'order_tracking_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  Future<void> placeOrder(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final driversSnapshot =
        await FirebaseFirestore.instance.collection('drivers').get();

    String? assignedDriver;
    double bestScore = double.infinity;
    String explanation = "";

    for (var doc in driversSnapshot.docs) {
      final data = doc.data();

      if (data['available'] == true) {
        double distance = (data['distance'] ?? 100).toDouble();

        // 🔥 scoring logic
        double score = distance;

        if (score < bestScore) {
          bestScore = score;
          assignedDriver = doc.id;
          explanation = "Selected driver ${doc.id} with distance $distance";
        }
      }
    }

    final orderRef =
        await FirebaseFirestore.instance.collection('orders').add({
      'userId': user.uid,
      'item': 'Burger',
      'price': 10,
      'status': 'placed',
      'driverId': assignedDriver,
      'score': bestScore,
      'explanation': explanation,
      'createdAt': Timestamp.now(),
    });

    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OrderTrackingScreen(orderId: orderRef.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Menu")),
      body: Column(
        children: [
          const ListTile(
            title: Text("Burger"),
            subtitle: Text("\$10"),
          ),
          ElevatedButton(
            onPressed: () => placeOrder(context),
            child: const Text("Order Burger"),
          ),
        ],
      ),
    );
  }
}