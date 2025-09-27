import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/cart/cart_cubit.dart';
import 'order_confirmation_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String orderId;
  final double totalAmount;

  const PaymentScreen({
    super.key,
    required this.orderId,
    required this.totalAmount,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _upiController = TextEditingController();
  final TextEditingController _cardController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();

  String _selectedPayment = '';

  void _showPaymentSheet(String method) {
    setState(() => _selectedPayment = method);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom, top: 20, left: 20, right: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Pay with $method',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (method == 'UPI')
                  TextFormField(
                    controller: _upiController,
                    decoration: const InputDecoration(labelText: 'UPI ID'),
                    validator: (value) {
                      if (value == null || !value.contains('@')) return 'Enter a valid UPI ID';
                      return null;
                    },
                  ),
                if (method == 'Card') ...[
                  TextFormField(
                    controller: _cardController,
                    decoration: const InputDecoration(labelText: 'Card Number'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.length != 16 || int.tryParse(value) == null) {
                        return 'Enter 16-digit card number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8,),
                  TextFormField(
                    controller: _cvvController,
                    decoration: const InputDecoration(labelText: 'CVV'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.length != 3 || int.tryParse(value) == null) {
                        return 'Enter 3-digit CVV';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8,),
                  TextFormField(
                    controller: _expiryController,
                    decoration: const InputDecoration(labelText: 'Expiry (MM/YY)'),
                    validator: (value) {
                      final regex = RegExp(r'^\d{2}/\d{2}$');
                      if (value == null || !regex.hasMatch(value)) return 'Enter MM/YY';
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _pay,
                    child: const Text('Pay', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void _pay() {
    if (_selectedPayment == 'Cash') {
      _completePayment();
      return;
    }

    if (_formKey.currentState!.validate()) {
      _completePayment();
    }
  }

  void _completePayment() {
    context.read<CartCubit>().clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => OrderConfirmationScreen(orderId: widget.orderId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Payment', style: TextStyle(shadows: [Shadow(color: Colors.black, blurRadius: 2.0)])), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('Total Amount', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text('\$${widget.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryColor)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: Icon(Icons.monetization_on_outlined, color: primaryColor,),
              title: const Text('UPI'),
              onTap: () => _showPaymentSheet('UPI'),
            ),
            ListTile(
              leading: Icon(Icons.credit_card,color: primaryColor, ),
              title: const Text('Card'),
              onTap: () => _showPaymentSheet('Card'),
            ),
            ListTile(
              leading: Icon(Icons.money,color: primaryColor,),
              title: const Text('Cash on Delivery'),
              onTap: () => _showPaymentSheet('Cash'),
            ),
          ],
        ),
      ),
    );
  }
}
