import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_app/blocs/restaurant/restaurant_bloc.dart';
import 'package:food_delivery_app/blocs/restaurant/restaurant_state.dart';
import 'package:food_delivery_app/blocs/restaurant/restaurant_event.dart';
import '../../data/models/restaurant.dart';
import 'package:food_delivery_app/ui/screens/menu_screen.dart';

class RestaurantListScreen extends StatelessWidget {
  const RestaurantListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Restaurants')),
      body: SafeArea(
        child: BlocBuilder<RestaurantBloc, RestaurantState>(
          builder: (context, state) {
            if (state is RestaurantLoadInProgress) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RestaurantLoadFailure) {
              return _ErrorView(message: state.message);
            } else if (state is RestaurantLoadSuccess) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<RestaurantBloc>().add(RestaurantRefreshRequested());
                },
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: state.restaurants.length,
                  itemBuilder: (context, idx) {
                    final r = state.restaurants[idx];
                    return _RestaurantCard(
                      restaurant: r,
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => MenuScreen(restaurant: r)));
                      },
                    );
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Cart'),
        icon: const Icon(Icons.shopping_cart),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => MenuScreen.openCart()),
          );
        },
      ),
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback onTap;
  const _RestaurantCard({required this.restaurant, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.white, Colors.grey.shade50]),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0,4))],
        ),
        child: Row(
          children: [
            Container(width: 72, height: 72, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8))),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(restaurant.name, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(restaurant.address, style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 6),
                  Row(children: [Icon(Icons.star,size:14,color:Colors.amber), Text('${restaurant.rating}')]),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message, super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('Oops', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          icon: const Icon(Icons.refresh),
          label: const Text('Retry'),
          onPressed: () => context.read<RestaurantBloc>().add(RestaurantFetchRequested()),
        )
      ]),
    );
  }
}
