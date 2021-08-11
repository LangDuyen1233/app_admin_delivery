class ListMaterialsJson {
  List<Materials> materials;

  ListMaterialsJson({this.materials});

  ListMaterialsJson.fromJson(Map<String, dynamic> json) {
    if (json['materials'] != null) {
      materials = new List<Materials>();
      json['materials'].forEach((v) {
        materials.add(new Materials.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.materials != null) {
      data['materials'] = this.materials.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MaterialsJson {
  Materials materials;

  MaterialsJson({this.materials});

  MaterialsJson.fromJson(Map<String, dynamic> json) {
    materials = json['materials'] != null
        ? new Materials.fromJson(json['materials'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.materials != null) {
      data['materials'] = this.materials.toJson();
    }
    return data;
  }
}

class Materials {
  int id;
  String name;
  int quantity;
  String image;
  int restaurantId;
  String createdAt;
  String updatedAt;

  Materials({
    this.id,
    this.name,
    this.quantity,
    this.image,
    this.restaurantId,
    this.createdAt,
    this.updatedAt,
  });

  Materials.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    quantity = json['quantity'];
    image = json['image'];
    restaurantId = json['restaurant_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['quantity'] = this.quantity;
    data['image'] = this.image;
    data['restaurant_id'] = this.restaurantId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
