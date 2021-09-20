class ListNotifyJson {
  List<Notify> notify;

  ListNotifyJson({this.notify});

  ListNotifyJson.fromJson(Map<String, dynamic> json) {
    if (json['notify'] != null) {
      notify = new List<Notify>();
      json['notify'].forEach((v) {
        notify.add(new Notify.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notify != null) {
      data['notify'] = this.notify.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notify {
  int id;
  String title;
  int notificationTypeId;
  int userId;
  String body;
  String createdAt;
  String updatedAt;
  NotifyType notifyType;

  Notify(
      {this.id,
        this.title,
        this.notificationTypeId,
        this.userId,
        this.body,
        this.createdAt,
        this.updatedAt,
        this.notifyType});

  Notify.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    notificationTypeId = json['notification_type_id'];
    userId = json['user_id'];
    body = json['body'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    notifyType = json['notify_type'] != null
        ? new NotifyType.fromJson(json['notify_type'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['notification_type_id'] = this.notificationTypeId;
    data['user_id'] = this.userId;
    data['body'] = this.body;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.notifyType != null) {
      data['notify_type'] = this.notifyType.toJson();
    }
    return data;
  }
}

class NotifyType {
  int id;
  String type;

  NotifyType({this.id, this.type});

  NotifyType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    return data;
  }
}
