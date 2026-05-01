import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'order_tracking_screen.dart';

class MenuScreen extends StatelessWidget {
  final String restaurantId;

  const MenuScreen({super.key, required this.restaurantId});

  Future<void> placeOrder(BuildContext context, String item, double price) async {
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
      'restaurantId': restaurantId,
      'item': item,
      'price': price,
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('restaurants')
            .doc(restaurantId)
            .collection('menu')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading menu'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final menuItems = snapshot.data?.docs ?? [];

          if (menuItems.isEmpty) {
            return const Center(
              child: Text('No menu items available'),
            );
          }

          return ListView.builder(
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final item = menuItems[index];
              final data = item.data() as Map<String, dynamic>;
              final name = data['name'] ?? 'Unknown Item';
              final price = (data['price'] ?? 0).toDouble();

              return ListTile(
                title: Text(name),
                subtitle: Text('\$${price.toStringAsFixed(2)}'),
                trailing: ElevatedButton(
                  onPressed: () => placeOrder(context, name, price),
                  child: const Text("Order"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}