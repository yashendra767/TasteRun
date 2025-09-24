import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/cart/cart_cubit.dart';
import 'package:food_delivery_app/domain/repository/restaurant_repository_interface.dart';
import 'order_confirmation_screen.dart';
import 'package:get_it/get_it.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _loading = false;
  String? _error;

  Future<void> _placeOrder() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final repo = GetIt.instance<IRestaurantRepository>();
    final cart = context.read<CartCubit>().state;
    try {
      final orderId = await repo.placeOrder(
        restaurantId: "r1",
        items: cart.items
            .map((ci) => {"id": ci.item.id, "qty": ci.qty})
            .toList(),
        total: cart.total,
      );
      context.read<CartCubit>().clear();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OrderConfirmationScreen(orderId: orderId),
        ),
      );
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = context.read<CartCubit>().state.total;
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Total to pay: \$${total.toStringAsFixed(2)}",
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            if (_error != null) ...[
              Text(_error!,
                  style: const TextStyle(color: Colors.redAccent)),
              const SizedBox(height: 12),
            ],
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _placeOrder,
              child: const Text("Place Order"),
            )
          ],
        ),
      ),
    );
  }
}
