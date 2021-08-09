class Users {
  int id;
  String username;
  String email;
  String phone;
  String gender;
  String avatar;
  String dob;
  String bio;
  int active;
  int roleId;
  String token;
  String randomKey;
  String keyTime;
  String expiresAt;
  String uid;

  Users(
      {this.id,
      this.username,
      this.email,
      this.phone,
      this.gender,
      this.avatar,
      this.dob,
      this.bio,
      this.active,
      this.roleId,
      this.token,
      this.randomKey,
      this.keyTime,
      this.expiresAt,
        this.uid,
      });

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    gender = json['gender'];
    avatar = json['avatar'];
    dob = json['dob'];
    bio = json['bio'];
    active = json['active'];
    roleId = json['role_id'];
    token = json['token'];
    randomKey = json['random_key'];
    keyTime = json['key_time'];
    expiresAt = json['expires_at'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['gender'] = this.gender;
    data['avatar'] = this.avatar;
    data['dob'] = this.dob;
    data['bio'] = this.bio;
    data['active'] = this.active;
    data['role_id'] = this.roleId;
    data['token'] = this.token;
    data['random_key'] = this.randomKey;
    data['key_time'] = this.keyTime;
    data['expires_at'] = this.expiresAt;
    data['uid'] = this.uid;
    return data;
  }
}

class UsersJson {
  Users users;

  UsersJson({this.users});

  UsersJson.fromJson(Map<String, dynamic> json) {
    users = json['users'] != null ? new Users.fromJson(json['users']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.users != null) {
      data['users'] = this.users.toJson();
    }
    return data;
  }
}
