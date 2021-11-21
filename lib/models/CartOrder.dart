import 'package:app_delivery/models/Food.dart';

class CartOrder {
  final double price;
  final Food food;
  final String status;
  final int quantity;

  CartOrder({this.price, this.food, this.status,this.quantity});
}
