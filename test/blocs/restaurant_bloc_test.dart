import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:food_delivery_app/blocs/restaurant/restaurant_bloc.dart';
import 'package:food_delivery_app/blocs/restaurant/restaurant_event.dart';
import 'package:food_delivery_app/blocs/restaurant/restaurant_state.dart';
import 'package:food_delivery_app/domain/repository//restaurant_repository_interface.dart';
import 'package:food_delivery_app/data/models/restaurant.dart';
import 'package:food_delivery_app/data/models/menu_item.dart';

class MockRepo extends Mock implements IRestaurantRepository {}

void main() {
  late MockRepo mockRepo;
  late RestaurantBloc bloc;

  setUp(() {
    mockRepo = MockRepo();
    bloc = RestaurantBloc(repository: mockRepo);
  });

  test('initial state is RestaurantInitial', () {
    expect(bloc.state, RestaurantInitial());
  });

  blocTest<RestaurantBloc, RestaurantState>(
    'emits [loading, success] when fetch succeeds',
    build: () {
      when(mockRepo.fetchRestaurants()).thenAnswer((_) async => [
        Restaurant(id: 'r1', name: 'r', cuisine: 'i', address: 'a', rating: 4.5, menuPreview: [MenuItem(id: 'm1', name: 'n', description: 'd', price: 1.0, imageUrl: '',)])
      ]);
      return bloc;
    },
    act: (b) => b.add(RestaurantFetchRequested()),
    expect: () => [isA<RestaurantLoadInProgress>(), isA<RestaurantLoadSuccess>()],
  );

  blocTest<RestaurantBloc, RestaurantState>(
    'emits [loading, failure] when fetch throws',
    build: () {
      when(mockRepo.fetchRestaurants()).thenThrow(Exception('network'));
      return bloc;
    },
    act: (b) => b.add(RestaurantFetchRequested()),
    expect: () => [isA<RestaurantLoadInProgress>(), isA<RestaurantLoadFailure>()],
  );
}
