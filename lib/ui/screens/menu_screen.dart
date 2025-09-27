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
        title: Text(
          widget.restaurant.name,
          style: const TextStyle(shadows: [Shadow(color: Colors.black, blurRadius: 2.0)]),
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, cartState) {
              final totalQty = cartState.items.fold<int>(0, (s, ci) => s + ci.qty);
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CartScreen()),
                      );
                    },
                  ),
                  if (totalQty > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                        child: Center(
                          child: Text(
                            totalQty.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
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
            final msg = snapshot.error is Failure ? (snapshot.error as Failure).message : 'Unexpected error';
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
                        _futureMenu = repo.fetchMenuForRestaurant(widget.restaurant.id);
                      });
                    },
                  )
                ],
              ),
            );
          } else {
            final menu = snapshot.data!;
            if (menu.isEmpty) {
              return const Center(child: Text('No items found'));
            }
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
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: item.imageUrl.isNotEmpty
                  ? Image.asset(
                item.imageUrl,
                width: 72,
                height: 72,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 72,
                  height: 72,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.fastfood, color: Colors.deepPurple, size: 32,),
                ),
              )
                  : Container(
                width: 72,
                height: 72,
                color: Colors.grey.shade200,
                child: const Icon(Icons.fastfood, color: Colors.deepPurple, size: 32,),
              ),
            ),
            const SizedBox(width: 12),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  if ((item.description).isNotEmpty)
                    Text(item.description, style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 8),
                  Text(
                    "\$${item.price.toStringAsFixed(2)}",
                    style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            BlocBuilder<CartCubit, CartState>(
              builder: (context, cartState) {
                final idx = cartState.items.indexWhere((ci) => ci.item.id == item.id);
                final qty = idx >= 0 ? cartState.items[idx].qty : 0;
                if (qty == 0) {
                  return IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.deepPurple),
                    onPressed: () {
                      context.read<CartCubit>().addItem(item);
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${item.name} added to cart'),
                          duration: const Duration(seconds: 3),
                          action: SnackBarAction(
                            label: 'View',
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
                            },
                          ),
                        ),
                      );
                    },
                  );
                }

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove_circle, color: Colors.red.shade300),
                      onPressed: () {
                        context.read<CartCubit>().removeOne(item);
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        qty.toString(),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.deepPurple),
                      onPressed: () {
                        context.read<CartCubit>().addItem(item);
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
