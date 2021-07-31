import 'package:app_delivery/models/Food.dart';

class ListTopping {
  List<Topping> topping;

  ListTopping({this.topping});

  ListTopping.fromJson(Map<String, dynamic> json) {
    if (json['topping'] != null) {
      topping = new List<Topping>();
      json['topping'].forEach((v) {
        topping.add(new Topping.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.topping != null) {
      data['topping'] = this.topping.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ToppingJson {
  Topping topping;

  ToppingJson({this.topping});

  ToppingJson.fromJson(Map<String, dynamic> json) {
    topping =
        json['topping'] != null ? new Topping.fromJson(json['topping']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.topping != null) {
      data['topping'] = this.topping.toJson();
    }
    return data;
  }
}

class Topping {
  int id;
  String name;
  int price;
  int status;
  PivotFoodTopping pivot;
  List<Food> food;
  PivotOrderTopping pivotOrderTopping;

  Topping(
      {this.id, this.name, this.price, this.status, this.pivot, this.food});

  Topping.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    status = json['status'];
    pivot = json['pivot'] != null ? new PivotFoodTopping.fromJson(json['pivot']) : null;
    if (json['food'] != null) {
      food = new List<Food>();
      json['food'].forEach((v) {
        food.add(new Food.fromJson(v));
      });
    }
    pivotOrderTopping = json['pivot'] != null ? new PivotOrderTopping.fromJson(json['pivot']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['status'] = this.status;
    if (this.pivot != null) {
      data['pivot'] = this.pivot.toJson();
    }
    if (this.food != null) {
      data['food'] = this.food.map((v) => v.toJson()).toList();
    }
    if (this.pivotOrderTopping != null) {
      data['pivot'] = this.pivotOrderTopping.toJson();
    }
    return data;
  }
}

class PivotFoodTopping {
  int toppingId;
  int foodId;

  PivotFoodTopping({this.toppingId, this.foodId});

  PivotFoodTopping.fromJson(Map<String, dynamic> json) {
    toppingId = json['topping_id'];
    foodId = json['food_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topping_id'] = this.toppingId;
    data['food_id'] = this.foodId;
    return data;
  }
}
class PivotOrderTopping {
  int foodOrdersId;
  int toppingId;

  PivotOrderTopping({this.foodOrdersId, this.toppingId});

  PivotOrderTopping.fromJson(Map<String, dynamic> json) {
    foodOrdersId = json['food_orders_id'];
    toppingId = json['topping_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['food_orders_id'] = this.foodOrdersId;
    data['topping_id'] = this.toppingId;
    return data;
  }
}
