import 'package:app_delivery/models/Food.dart';

class ListDiscountJson {
  List<Discount> discount;

  ListDiscountJson({this.discount});

  ListDiscountJson.fromJson(Map<String, dynamic> json) {
    if (json['discount'] != null) {
      discount = new List<Discount>();
      json['discount'].forEach((v) {
        discount.add(new Discount.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.discount != null) {
      data['discount'] = this.discount.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DiscountJson {
  Discount discount;

  DiscountJson({this.discount});

  DiscountJson.fromJson(Map<String, dynamic> json) {
    discount = json['discount'] != null
        ? new Discount.fromJson(json['discount'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.discount != null) {
      data['discount'] = this.discount.toJson();
    }
    return data;
  }
}

class Discount {
  int id;
  String name;
  String code;
  String percent;
  int status;
  String startDate;
  String endDate;
  int restaurantId;
  int typeDiscountId;
  TypeDiscount typeDiscount;
  List<Food> food;

  Discount(
      {this.id,
      this.name,
      this.code,
      this.percent,
      this.status,
      this.startDate,
      this.endDate,
      this.restaurantId,
      this.typeDiscountId,
      this.typeDiscount,
      this.food});

  Discount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    percent = json['percent'];
    status = json['status'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    restaurantId = json['restaurant_id'];
    typeDiscountId = json['type_discount_id'];
    typeDiscount = json['type_discount'] != null
        ? new TypeDiscount.fromJson(json['type_discount'])
        : null;
    if (json['food'] != null) {
      food = new List<Food>();
      json['food'].forEach((v) {
        food.add(new Food.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['percent'] = this.percent;
    data['status'] = this.status;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['restaurant_id'] = this.restaurantId;
    data['type_discount_id'] = this.typeDiscountId;
    if (this.typeDiscount != null) {
      data['type_discount'] = this.typeDiscount.toJson();
    }
    if (this.food != null) {
      data['food'] = this.food.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TypeDiscount {
  int id;
  String type;
  String content;

  TypeDiscount({this.id, this.type});

  TypeDiscount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['content'] = this.content;
    return data;
  }
}
