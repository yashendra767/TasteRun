import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'di/injection.dart' as di;
import 'ui/screens/restaurant_list_screen.dart';
import 'package:food_delivery_app/blocs/restaurant/restaurant_bloc.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final getIt = GetIt.instance;
    return MultiBlocProvider(
      providers: [
        BlocProvider<RestaurantBloc>(
          create: (_) => getIt<RestaurantBloc>()..add(RestaurantFetchRequested()),
        ),
        BlocProvider(
          create: (_) => getIt(),
        ),
      ],
      child: MaterialApp(

        debugShowCheckedModeBanner: false,
        title: 'Foodie',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6C63FF),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFF7F7FB),
        ),
        home: const RestaurantListScreen(),
      ),
    );
  }
}
