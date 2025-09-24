import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:food_delivery_app/domain/repository/restaurant_repository_interface.dart';
import '../../data/models/restaurant.dart';
import '../../core/errors/failures.dart';
import 'menu_screen.dart';

class RestaurantListScreen extends StatefulWidget {
  const RestaurantListScreen({super.key});

  @override
  State<RestaurantListScreen> createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  late Future<List<Restaurant>> _futureRestaurants;

  @override
  void initState() {
    super.initState();
    final repo = GetIt.instance<IRestaurantRepository>();
    _futureRestaurants = repo.fetchRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Restaurants")),
      body: FutureBuilder<List<Restaurant>>(
        future: _futureRestaurants,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            final msg = snapshot.error is Failure
                ? (snapshot.error as Failure).message
                : "Something went wrong";
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(msg),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        final repo = GetIt.instance<IRestaurantRepository>();
                        _futureRestaurants = repo.fetchRestaurants();
                      });
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text("Retry"),
                  ),
                ],
              ),
            );
          } else {
            final restaurants = snapshot.data!;
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: restaurants.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final r = restaurants[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                  child: ListTile(
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    title: Text(r.name,
                        style: Theme.of(context).textTheme.titleMedium),
                    subtitle: Text(r.cuisine),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MenuScreen(restaurant: r),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
