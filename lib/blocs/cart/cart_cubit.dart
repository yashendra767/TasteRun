import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/cart_item.dart';
import '../../data/models/menu_item.dart';

class CartState {
  final List<CartItem> items;
  const CartState(this.items);

  double get total => items.fold(0.0, (sum, e) => sum + e.item.price * e.qty);
}

class CartCubit extends Cubit<CartState> {
  CartCubit(): super(const CartState([]));

  void addItem(MenuItem item) {
    final idx = state.items.indexWhere((ci) => ci.item.id == item.id);
    final items = List<CartItem>.from(state.items);
    if (idx >= 0) {
      items[idx] = items[idx].copyWith(qty: items[idx].qty + 1);
    } else {
      items.add(CartItem(item: item, qty: 1));
    }
    emit(CartState(items));
  }

  void removeOne(MenuItem item) {
    final idx = state.items.indexWhere((ci) => ci.item.id == item.id);
    if (idx < 0) return;
    final items = List<CartItem>.from(state.items);
    final current = items[idx];
    if (current.qty > 1) {
      items[idx] = current.copyWith(qty: current.qty - 1);
    } else {
      items.removeAt(idx);
    }
    emit(CartState(items));
  }

  void removeItemCompletely(MenuItem item) {
    final items = state.items.where((ci) => ci.item.id != item.id).toList();
    emit(CartState(items));
  }

  void clear() => emit(const CartState([]));
}
