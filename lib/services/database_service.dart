import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  static Future<void> seedSampleData() async {
    final firestore = FirebaseFirestore.instance;

    // Add sample restaurants
    final pizzaShopRef = await firestore.collection('restaurants').add({
      'name': 'Pizza Palace',
    });

    // Add menu items for Pizza Palace
    await pizzaShopRef.collection('menu').add({
      'name': 'Margherita Pizza',
      'price': 12.99,
    });

    await pizzaShopRef.collection('menu').add({
      'name': 'Pepperoni Pizza',
      'price': 14.99,
    });

    await pizzaShopRef.collection('menu').add({
      'name': 'Veggie Pizza',
      'price': 13.49,
    });

    final burgerJointRef = await firestore.collection('restaurants').add({
      'name': 'Burger Joint',
    });

    // Add menu items for Burger Joint
    await burgerJointRef.collection('menu').add({
      'name': 'Classic Burger',
      'price': 9.99,
    });

    await burgerJointRef.collection('menu').add({
      'name': 'Cheese Burger',
      'price': 10.99,
    });

    await burgerJointRef.collection('menu').add({
      'name': 'Bacon Burger',
      'price': 12.49,
    });

    // Add a sample driver
    await firestore.collection('drivers').add({
      'available': true,
      'distance': 5.0,
    });
  }
}