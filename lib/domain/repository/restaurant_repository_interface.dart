import '../../data/models/restaurant.dart';
import '../../data/models/menu_item.dart';

abstract class IRestaurantRepository {
  Future<List<Restaurant>> fetchRestaurants();
  Future<List<MenuItem>> fetchMenuForRestaurant(String restaurantId);
  Future<String> placeOrder({
    required String restaurantId,
    required List<Map<String, dynamic>> items,
    required double total,
  });
}
