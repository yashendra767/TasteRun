import 'package:equatable/equatable.dart';
import '../../data/models/restaurant.dart';

abstract class RestaurantState extends Equatable {
  const RestaurantState();
  @override List<Object?> get props => [];
}

class RestaurantInitial extends RestaurantState {}
class RestaurantLoadInProgress extends RestaurantState {}
class RestaurantLoadSuccess extends RestaurantState {
  final List<Restaurant> restaurants;
  const RestaurantLoadSuccess(this.restaurants);
  @override List<Object?> get props => [restaurants];
}
class RestaurantLoadFailure extends RestaurantState {
  final String message;
  const RestaurantLoadFailure(this.message);
  @override List<Object?> get props => [message];
}
