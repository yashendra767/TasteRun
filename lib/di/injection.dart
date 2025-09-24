import 'package:get_it/get_it.dart';
import 'package:food_delivery_app/data/repository/restaurant_repository.dart';
import 'package:food_delivery_app/domain/repository/restaurant_repository_interface.dart';
import 'package:food_delivery_app/blocs/restaurant/restaurant_bloc.dart';
import '../blocs/cart/cart_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // repositories
  sl.registerLazySingleton<IRestaurantRepository>(() => FakeRestaurantRepository());
  sl.registerFactory(() => RestaurantBloc(repository: sl()));
  sl.registerSingleton<CartCubit>(CartCubit());
}
