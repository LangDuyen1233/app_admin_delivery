import 'Category.dart';

class RestaurantJson {
  Restaurants restaurants;

  RestaurantJson({this.restaurants});

  RestaurantJson.fromJson(Map<String, dynamic> json) {
    restaurants = json['restaurants'] != null
        ? new Restaurants.fromJson(json['restaurants'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.restaurants != null) {
      data['restaurants'] = this.restaurants.toJson();
    }
    return data;
  }
}

class Restaurants {
  int id;
  String name;
  String address;
  String image;
  String lattitude;
  String longtitude;
  String description;
  String phone;
  String rating;
  int userId;
  int active;
  List<Category> category;

  Restaurants(
      {this.id,
      this.name,
      this.address,
      this.image,
      this.lattitude,
      this.longtitude,
      this.description,
      this.phone,
      this.rating,
      this.userId,
      this.active,
      this.category});

  Restaurants.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    image = json['image'];
    lattitude = json['lattitude'];
    longtitude = json['longtitude'];
    description = json['description'];
    phone = json['phone'];
    rating = json['rating'];
    userId = json['user_id'];
    active = json['active'];
    if (json['category'] != null) {
      category = new List<Category>();
      json['category'].forEach((v) {
        category.add(new Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['image'] = this.image;
    data['lattitude'] = this.lattitude;
    data['longtitude'] = this.longtitude;
    data['description'] = this.description;
    data['phone'] = this.phone;
    data['rating'] = this.rating;
    data['user_id'] = this.userId;
    data['active'] = this.active;
    if (this.category != null) {
      data['category'] = this.category.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
