import 'package:flutter_bloc/flutter_bloc.dart';
import 'restaurant_event.dart';
import 'restaurant_state.dart';
import 'package:food_delivery_app/domain/repository/restaurant_repository_interface.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final IRestaurantRepository repository;
  RestaurantBloc({required this.repository}) : super(RestaurantInitial()) {
    on<RestaurantFetchRequested>(_onFetch);
    on<RestaurantRefreshRequested>(_onRefresh);
  }

  Future<void> _onFetch(RestaurantFetchRequested event, Emitter emit) async {
    emit(RestaurantLoadInProgress());
    try {
      final list = await repository.fetchRestaurants();
      emit(RestaurantLoadSuccess(list));
    } catch (e) {
      emit(RestaurantLoadFailure(e is Exception ? e.toString() : 'Unknown error'));
    }
  }

  Future<void> _onRefresh(RestaurantRefreshRequested event, Emitter emit) async {
    try {
      final list = await repository.fetchRestaurants();
      emit(RestaurantLoadSuccess(list));
    } catch (e) {
      emit(RestaurantLoadFailure(e is Exception ? e.toString() : 'Unknown error'));
    }
  }
}
