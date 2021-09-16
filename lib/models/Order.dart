import 'Food.dart';
import 'FoodOrder.dart';
import 'Staff.dart';
import 'User.dart';

class ListOrderJson {
  List<Order> order;

  ListOrderJson({this.order});

  ListOrderJson.fromJson(Map<String, dynamic> json) {
    if (json['order'] != null) {
      order = new List<Order>();
      json['order'].forEach((v) {
        order.add(new Order.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.order != null) {
      data['order'] = this.order.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Order {
  int id;
  double tax;
  int price;
  int priceDelivery;
  String addressDelivery;
  String date;
  int orderStatusId;
  int paymentId;
  int discountId;
  String note;
  int status;
  int userId;
  int userDeliveryId;
  int staffId;
  String reason;
  Users user;
  Staff staff;
  StatusOrder statusOrder;
  Payment payment;
  String createdAt;
  String updatedAt;
  List<Food> food;
  List<FoodOrder> foodOrder;
  String latitude;
  String longitude;

  Order(
      {this.id,
      this.tax,
      this.price,
      this.priceDelivery,
      this.addressDelivery,
      this.date,
      this.orderStatusId,
      this.paymentId,
      this.discountId,
      this.note,
      this.status,
      this.userId,
      this.userDeliveryId,
      this.staffId,
      this.reason,
      this.user,
      this.staff,
      this.statusOrder,
      this.payment,
      this.createdAt,
      this.updatedAt,
      this.food,
      this.foodOrder,
        this.latitude,
        this.longitude,
      });

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tax = json['tax'];
    price = json['price'];
    priceDelivery = json['price_delivery'];
    addressDelivery = json['address_delivery'];
    date = json['date'];
    orderStatusId = json['order_status_id'];
    paymentId = json['payment_id'];
    discountId = json['discount_id'];
    note = json['note'];
    status = json['status'];
    userId = json['user_id'];
    staffId = json['staff_id'];
    userDeliveryId = json['user_delivery_id'];
    reason = json['reson'];
    user = json['user'] != null ? new Users.fromJson(json['user']) : null;
    staff = json['staff'] != null ? new Staff.fromJson(json['staff']) : null;
    statusOrder = json['status_order'] != null
        ? new StatusOrder.fromJson(json['status_order'])
        : null;
    payment =
        json['payment'] != null ? new Payment.fromJson(json['payment']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['food'] != null) {
      food = new List<Food>();
      json['food'].forEach((v) {
        food.add(new Food.fromJson(v));
      });
    }
    if (json['food_order'] != null) {
      foodOrder = new List<FoodOrder>();
      json['food_order'].forEach((v) {
        foodOrder.add(new FoodOrder.fromJson(v));
      });
    }
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tax'] = this.tax;
    data['price'] = this.price;
    data['price_delivery'] = this.priceDelivery;
    data['address_delivery'] = this.addressDelivery;
    data['date'] = this.date;
    data['order_status_id'] = this.orderStatusId;
    data['payment_id'] = this.paymentId;
    data['discount_id'] = this.discountId;
    data['note'] = this.note;
    data['status'] = this.status;
    data['user_id'] = this.userId;
    data['staff_id'] = this.staffId;
    data['user_delivery_id'] = this.userDeliveryId;
    data['reason'] = this.reason;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.staff != null) {
      data['staff'] = this.staff.toJson();
    }
    if (this.statusOrder != null) {
      data['status_order'] = this.statusOrder.toJson();
    }
    if (this.payment != null) {
      data['payment'] = this.payment.toJson();
    }
    if (this.food != null) {
      data['food'] = this.food.map((v) => v.toJson()).toList();
    }
    if (this.foodOrder != null) {
      data['food_order'] = this.foodOrder.map((v) => v.toJson()).toList();
    }
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class StatusOrder {
  int id;
  String status;

  StatusOrder({this.id, this.status});

  StatusOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    return data;
  }
}

class Payment {
  int id;
  int price;
  String description;
  Null userId;
  String method;
  String status;

  Payment({
    this.id,
    this.price,
    this.description,
    this.userId,
    this.method,
    this.status,
  });

  Payment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    description = json['description'];
    userId = json['user_id'];
    method = json['method'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['price'] = this.price;
    data['description'] = this.description;
    data['user_id'] = this.userId;
    data['method'] = this.method;
    data['status'] = this.status;
    return data;
  }
}

class PivotOrderFood {
  int orderId;
  int foodId;

  PivotOrderFood({this.orderId, this.foodId});

  PivotOrderFood.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    foodId = json['food_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['food_id'] = this.foodId;
    return data;
  }
}
