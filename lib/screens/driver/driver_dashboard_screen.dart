import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'driver_map_screen.dart';

class DriverDashboardScreen extends StatelessWidget {
  const DriverDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentDriverId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Driver Dashboard"),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DriverMapScreen(),
                ),
              );
            },
            child: const Text("Open Map"),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .where('driverId', isEqualTo: currentDriverId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Error loading assigned orders."),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final orders = snapshot.data!.docs;

                if (orders.isEmpty) {
                  return const Center(child: Text("No assigned orders"));
                }

                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final data = order.data() as Map<String, dynamic>;

                    final item = data['item'] ?? 'Order';
                    final status = data['status'] ?? 'unknown';
                    final score = data['score'] ?? 'N/A';
                    final explanation = data['explanation'] ?? '';

                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(item),
                        subtitle: Text(
                          "Status: $status\nScore: $score\n$explanation",
                        ),
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
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}