import 'package:flutter/material.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final String orderId;
  const OrderConfirmationScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order Confirmation")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle,
                  color: Colors.green, size: 72),
              const SizedBox(height: 16),
              Text("Your order has been placed!",
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              Text("Order ID: $orderId",
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (r) => r.isFirst);
                },
                child: const Text("Back to Restaurants"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
