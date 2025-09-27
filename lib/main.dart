import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'blocs/cart/cart_cubit.dart';
import 'config/theme.dart';
import 'data/repository/restaurant_repository.dart';
import 'domain/repository/restaurant_repository_interface.dart';
import 'ui/screens/restaurant_list_screen.dart';

void main() {
  GetIt.I.registerLazySingleton<IRestaurantRepository>(
        () => FakeRestaurantRepository(),
  );

  runApp(const FoodDeliveryApp());
}

class FoodDeliveryApp extends StatelessWidget {
  const FoodDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Food Delivery App',
        theme: appTheme,
        home: const RestaurantListScreen(),
      ),
    );
  }
}
