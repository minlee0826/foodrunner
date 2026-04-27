import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DriverDashboardScreen extends StatelessWidget {
  const DriverDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Driver Dashboard")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('status', isEqualTo: 'placed')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!.docs;

          if (orders.isEmpty) {
            return const Center(child: Text("No orders available"));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              return ListTile(
                title: Text(order['item']),
                subtitle: Text("Status: ${order['status']}"),
                trailing: ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('orders')
                        .doc(order.id)
                        .update({
                      'status': 'picked_up',
                    });
                  },
                  child: const Text("Pick Up"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}