import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/restaurant.dart';
import '../../data/models/menu_item.dart';
import '../../blocs/cart/cart_cubit.dart';
import 'package:food_delivery_app/domain/repository/restaurant_repository_interface.dart';
import '../../core/errors/failures.dart';
import 'cart_screen.dart';
import 'package:get_it/get_it.dart';

class MenuScreen extends StatefulWidget {
  final Restaurant restaurant;
  const MenuScreen({super.key, required this.restaurant});

  static Widget openCart() => const CartScreen();

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late Future<List<MenuItem>> _futureMenu;

  @override
  void initState() {
    super.initState();
    final repo = GetIt.instance<IRestaurantRepository>();
    _futureMenu = repo.fetchMenuForRestaurant(widget.restaurant.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurant.name, style: TextStyle(shadows: [Shadow(color: Colors.black, blurRadius: 2.0)]),),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<MenuItem>>(
        future: _futureMenu,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            final msg = snapshot.error is Failure
                ? (snapshot.error as Failure).message
                : 'Unexpected error';
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(msg, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    onPressed: () {
                      setState(() {
                        final repo = GetIt.instance<IRestaurantRepository>();
                        _futureMenu =
                            repo.fetchMenuForRestaurant(widget.restaurant.id);
                      });
                    },
                  )
                ],
              ),
            );
          } else {
            final menu = snapshot.data!;
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: menu.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, idx) {
                final item = menu[idx];
                return _MenuItemCard(item: item);
              },
            );
          }
        },
      ),
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final MenuItem item;
  const _MenuItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.fastfood, size: 32, color: Colors.deepPurple),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(item.description,
                      style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 8),
                  Text("\$${item.price.toStringAsFixed(2)}",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.deepPurple),
              onPressed: () {
                context.read<CartCubit>().addItem(item);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${item.name} added to cart'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
