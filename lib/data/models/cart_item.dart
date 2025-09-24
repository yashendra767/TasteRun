import 'menu_item.dart';
import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final MenuItem item;
  final int qty;

  const CartItem({required this.item, required this.qty});

  CartItem copyWith({int? qty}) => CartItem(item: item, qty: qty ?? this.qty);

  @override
  List<Object?> get props => [item, qty];
}
