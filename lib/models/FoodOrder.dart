import 'package:app_delivery/models/Food.dart';

import 'Topping.dart';
class FoodOrder {
  int id;
  int price;
  int quantity;
  int foodId;
  int orderId;
  Food food;
  List<Topping> toppings;

  FoodOrder(
      {this.id,
        this.price,
        this.quantity,
        this.foodId,
        this.orderId,
        this.food,
        this.toppings});

  FoodOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    quantity = json['quantity'];
    foodId = json['food_id'];
    orderId = json['order_id'];
    food = json['food'] != null ? new Food.fromJson(json['food']) : null;
    if (json['toppings'] != null) {
      toppings = new List<Topping>();
      json['toppings'].forEach((v) {
        toppings.add(new Topping.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['food_id'] = this.foodId;
    data['order_id'] = this.orderId;
    if (this.food != null) {
      data['food'] = this.food.toJson();
    }
    if (this.toppings != null) {
      data['toppings'] = this.toppings.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
