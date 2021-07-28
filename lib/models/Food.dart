import 'package:app_delivery/models/Restaurant.dart';
import 'package:app_delivery/models/Topping.dart';

import 'Category.dart';
import 'Image.dart';

class ListFoodJson {
  List<Food> food;

  ListFoodJson({this.food});

  ListFoodJson.fromJson(Map<String, dynamic> json) {
    if (json['food'] != null) {
      food = new List<Food>();
      json['food'].forEach((v) {
        food.add(new Food.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.food != null) {
      data['food'] = this.food.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FoodJson {
  Food food;

  FoodJson({this.food});

  FoodJson.fromJson(Map<String, dynamic> json) {
    food = json['food'] != null ? new Food.fromJson(json['food']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.food != null) {
      data['food'] = this.food.toJson();
    }
    return data;
  }
}

class Food {
  int id;
  String name;
  String size;
  int price;
  String weight;
  String ingredients;
  int status;
  int restaurantId;
  int categoryId;
  Category category;
  Restaurants restaurant;
  List<Image> image;
  List<Topping> topping;
  PivotFoodTopping pivot;


  Food(
      {this.id,
      this.name,
      this.size,
      this.price,
      this.weight,
      this.ingredients,
      this.status,
      this.restaurantId,
      this.categoryId,
      this.category,
      this.restaurant,
      this.image,
      this.topping,this.pivot});

  Food.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    size = json['size'];
    price = json['price'];
    weight = json['weight'];
    ingredients = json['ingredients'];
    status = json['status'];
    restaurantId = json['restaurant_id'];
    categoryId = json['category_id'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    restaurant = json['restaurant'] != null
        ? new Restaurants.fromJson(json['restaurant'])
        : null;
    if (json['image'] != null) {
      image = new List<Image>();
      json['image'].forEach((v) {
        image.add(new Image.fromJson(v));
      });
    }
    if (json['toppings'] != null) {
      topping = new List<Topping>();
      json['toppings'].forEach((v) {
        topping.add(new Topping.fromJson(v));
      });
    }
    pivot = json['pivot'] != null ? new PivotFoodTopping.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['size'] = this.size;
    data['price'] = this.price;
    data['weight'] = this.weight;
    data['ingredients'] = this.ingredients;
    data['status'] = this.status;
    data['restaurant_id'] = this.restaurantId;
    data['category_id'] = this.categoryId;
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    if (this.restaurant != null) {
      data['restaurant'] = this.restaurant.toJson();
    }
    if (this.image != null) {
      data['image'] = this.image.map((v) => v.toJson()).toList();
    }
    if (this.topping != null) {
      data['topping'] = this.topping.map((v) => v.toJson()).toList();
    }
    if (this.pivot != null) {
      data['pivot'] = this.pivot.toJson();
    }
    return data;
  }
}
