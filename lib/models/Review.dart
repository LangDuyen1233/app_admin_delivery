import 'package:app_delivery/models/Restaurant.dart';

import 'Image.dart';
import 'User.dart';

class ListReviewJson {
  List<Review> review;

  ListReviewJson({this.review});

  ListReviewJson.fromJson(Map<String, dynamic> json) {
    if (json['review'] != null) {
      review = new List<Review>();
      json['review'].forEach((v) {
        review.add(new Review.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.review != null) {
      data['review'] = this.review.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Review {
  int id;
  String review;
  String rate;
  int restaurantId;
  int userId;
  int status;
  Users user;
  Restaurants restaurant;
  List<Image> image;
  String updatedAt;

  Review(
      {this.id,
      this.review,
      this.rate,
      this.restaurantId,
      this.userId,
      this.status,
      this.user,
      this.restaurant,
      this.image,
        this.updatedAt,
      });

  Review.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    review = json['review'];
    rate = json['rate'];
    restaurantId = json['restaurant_id'];
    userId = json['user_id'];
    status = json['status'];
    user = json['user'] != null ? new Users.fromJson(json['user']) : null;
    restaurant = json['restaurant'] != null
        ? new Restaurants.fromJson(json['restaurant'])
        : null;
    if (json['image'] != null) {
      image = new List<Image>();
      json['image'].forEach((v) {
        image.add(new Image.fromJson(v));
      });
    }
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['review'] = this.review;
    data['rate'] = this.rate;
    data['restaurant_id'] = this.restaurantId;
    data['user_id'] = this.userId;
    data['status'] = this.status;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.restaurant != null) {
      data['restaurant'] = this.restaurant.toJson();
    }
    if (this.image != null) {
      data['image'] = this.image.map((v) => v.toJson()).toList();
    }
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
