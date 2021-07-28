class Image {
  int id;
  String url;
  int foodReviewId;
  Pivot pivot;

  Image({this.id, this.url, this.foodReviewId, this.pivot});

  Image.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    foodReviewId = json['food_review_id'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['food_review_id'] = this.foodReviewId;
    if (this.pivot != null) {
      data['pivot'] = this.pivot.toJson();
    }
    return data;
  }
}

class Pivot {
  int foodId;
  int imageId;

  Pivot({this.foodId, this.imageId});

  Pivot.fromJson(Map<String, dynamic> json) {
    foodId = json['food_id'];
    imageId = json['image_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['food_id'] = this.foodId;
    data['image_id'] = this.imageId;
    return data;
  }
}
