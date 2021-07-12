import 'package:app_delivery/models/Food.dart';

class CartOrder {
  final double price;
  final Food food;
  final String status;
  final int quantity;

  CartOrder({this.price, this.food, this.status,this.quantity});
}
List<CartOrder> list = [
  CartOrder(
    quantity: 1,
    food: f1,
    status: 'khong bỏ hành lá',
    price: 135.00
  ),
  CartOrder(
      quantity: 2,
      food: f2,
      status: 'khong bỏ đá',
      price: 135.00
  ),
  CartOrder(
      quantity: 1,
      food: f3,
      status: 'khong bỏ hành lá',
      price: 135.00
  )
];
