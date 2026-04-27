import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;

  const OrderTrackingScreen({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Tracking"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(orderId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error loading order."),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          final item = data['item'] ?? 'Order';
          final status = data['status'] ?? 'unknown';
          final price = data['price'] ?? 0;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item,
                  style: const TextStyle(fontSize: 28),
                ),
                const SizedBox(height: 10),
                Text(
                  "Price: \$$price",
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                Text(
                  "Status: $status",
                  style: const TextStyle(fontSize: 24),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}