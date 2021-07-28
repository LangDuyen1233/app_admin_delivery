class ListStaffJson {
  List<Staff> staff;

  ListStaffJson({this.staff});

  ListStaffJson.fromJson(Map<String, dynamic> json) {
    if (json['staff'] != null) {
      staff = new List<Staff>();
      json['staff'].forEach((v) {
        staff.add(new Staff.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.staff != null) {
      data['staff'] = this.staff.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class StaffJson {
  Staff staff;

  StaffJson({this.staff});

  StaffJson.fromJson(Map<String, dynamic> json) {
    staff = json['staff'] != null ? new Staff.fromJson(json['staff']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.staff != null) {
      data['staff'] = this.staff.toJson();
    }
    return data;
  }
}

class Staff {
  int id;
  String name;
  int salary;
  String avatar;
  String startDate;
  String endDate;
  String gender;
  String dob;
  String address;
  String phone;
  int restaurantId;

  Staff({
    this.id,
    this.name,
    this.salary,
    this.avatar,
    this.startDate,
    this.endDate,
    this.gender,
    this.dob,
    this.address,
    this.phone,
    this.restaurantId,
  });

  Staff.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    salary = json['salary'];
    avatar = json['avatar'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    gender = json['gender'];
    dob = json['dob'];
    address = json['address'];
    phone = json['phone'];
    restaurantId = json['restaurant_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['salary'] = this.salary;
    data['avatar'] = this.avatar;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['restaurant_id'] = this.restaurantId;
    return data;
  }
}
