import 'package:flutter/material.dart';

class RestaurantDashboardScreen extends StatelessWidget {
  const RestaurantDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurant Dashboard"),
      ),
      body: const Center(
        child: Text("Welcome Restaurant"),
      ),
    );
  }
}