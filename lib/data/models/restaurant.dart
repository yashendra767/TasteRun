import 'package:equatable/equatable.dart';
import 'menu_item.dart';

class Restaurant extends Equatable {
  final String id;
  final String name;
  final String address;
  final double rating;
  final String cuisine;
  final List<MenuItem> menuPreview;

  const Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.rating,
    required this.cuisine,
    required this.menuPreview,
  });

  @override
  List<Object?> get props => [id, name, address, rating];
}
