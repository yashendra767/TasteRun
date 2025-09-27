import 'package:flutter/material.dart';
import 'package:food_delivery_app/config/theme.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  final List<Map<String, dynamic>> _orders = const [
    {
      "restaurant": "Slice and Dice",
      "date": "2025-09-27",
      "total": 25.99,
      "items": ["Margherita Pizza x1", "Coke x2"]
    },
    {
      "restaurant": "Curry House",
      "date": "2025-09-20",
      "total": 40.50,
      "items": ["Butter Paneer x2", "Naan x1"]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History", style: TextStyle(shadows: [Shadow(color: Colors.black, blurRadius: 2.0)])),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final order = _orders[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order["restaurant"], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),),
                  const SizedBox(height: 4),
                  Text("Date: ${order["date"]}", style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text("Total: \$${order["total"].toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("Items: ${order["items"].join(", ")}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}