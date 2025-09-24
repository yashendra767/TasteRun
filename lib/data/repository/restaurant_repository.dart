import 'dart:math';
import 'dart:async';
import 'package:food_delivery_app/domain/repository/restaurant_repository_interface.dart';
import '../models/restaurant.dart';
import '../models/menu_item.dart';
import 'package:food_delivery_app/core/errors/failures.dart';

class FakeRestaurantRepository implements IRestaurantRepository {
  final Random _random = Random();

  Future<void> _maybeDelay() async {
    await Future.delayed(Duration(milliseconds: 700 + _random.nextInt(800)));
  }

  @override
  Future<List<Restaurant>> fetchRestaurants() async {
    await _maybeDelay();
    if (_random.nextInt(10) < 2) {
      throw NetworkFailure('Failed to fetch restaurants');
    }
    // small sample
    final menu1 = [
      MenuItem(id: 'm1', name: 'Margherita Pizza', description: 'Classic', price: 6.99, imageUrl: ''),
      MenuItem(id: 'm2', name: 'Veg Burger', description: 'With fries', price: 4.50, imageUrl: ''),
    ];
    final menu2 = [
      MenuItem(id: 'm3', name: 'Butter Chicken', description: 'Creamy', price: 8.50, imageUrl: ''),
      MenuItem(id: 'm4', name: 'Naan', description: 'Buttery', price: 1.50, imageUrl: ''),
    ];

    return [
      Restaurant(id: 'r1', name: 'Slice & Dice', address: '12 Baker St', rating: 4.6, menuPreview: menu1, cuisine: 'Italian'),
      Restaurant(id: 'r2', name: 'Curry House', address: '45 Spice Ave', rating: 4.4, menuPreview: menu2, cuisine: 'Indian'),
    ];
  }

  @override
  Future<List<MenuItem>> fetchMenuForRestaurant(String restaurantId) async {
    await _maybeDelay();
    if (_random.nextInt(10) < 2) {
      throw NetworkFailure('Failed to fetch menu');
    }
    // return based on ID
    if (restaurantId == 'r1') {
      return [
        MenuItem(id: 'm1', name: 'Margherita Pizza', description: 'Classic', price: 6.99, imageUrl: ''),
        MenuItem(id: 'm5', name: 'Pepperoni', description: 'Spicy', price: 7.99, imageUrl: ''),
      ];
    } else {
      return [
        MenuItem(id: 'm3', name: 'Butter Chicken', description: 'Creamy', price: 8.50, imageUrl: ''),
        MenuItem(id: 'm4', name: 'Naan', description: 'Buttery', price: 1.50, imageUrl: ''),
      ];
    }
  }

  @override
  Future<String> placeOrder({required String restaurantId, required List<Map<String, dynamic>> items, required double total}) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    // Simulate occasional failure
    if (_random.nextInt(10) < 2) {
      throw ServerFailure('Payment gateway error');
    }
    // Return fake order id
    return 'ORD-${DateTime.now().millisecondsSinceEpoch % 100000}';
  }
}
