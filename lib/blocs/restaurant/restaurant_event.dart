import 'package:equatable/equatable.dart';

abstract class RestaurantEvent extends Equatable {
  const RestaurantEvent();
  @override List<Object?> get props => [];
}

class RestaurantFetchRequested extends RestaurantEvent {}
class RestaurantRefreshRequested extends RestaurantEvent {}
