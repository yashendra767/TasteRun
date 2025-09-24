import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery_app/blocs/cart/cart_cubit.dart';
import 'package:food_delivery_app/data/models/menu_item.dart';

void main() {
  late CartCubit cubit;
  setUp(() => cubit = CartCubit());

  test('add item increases qty', () {
    final item = MenuItem(id: 'm1', name: 'A', description: 'd', price: 5.0, imageUrl: '');
    cubit.addItem(item);
    expect(cubit.state.items.length, 1);
    expect(cubit.state.items.first.qty, 1);
    cubit.addItem(item);
    expect(cubit.state.items.first.qty, 2);
  });

  test('removeOne decreases qty', () {
    final item = MenuItem(id: 'm1', name: 'A', description: 'd', price: 5.0, imageUrl: '');
    cubit.addItem(item);
    cubit.addItem(item);
    cubit.removeOne(item);
    expect(cubit.state.items.first.qty, 1);
    cubit.removeOne(item);
    expect(cubit.state.items.length, 0);
  });
}
