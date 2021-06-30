///
/// Description:
/// Author: ArcherHan
/// Date: 2021-06-30 14:04:15
/// LastEditors: ArcherHan
/// LastEditTime: 2021-06-30 14:04:23
///
class Todo {
  String? lastTime;
  String? addTime;
  String? content;
  int? id;
  int? status;

  Todo({this.lastTime, this.addTime, this.content, this.id, this.status});

  Todo.fromJson(Map<String, dynamic> json) {
    lastTime = json['last_time'];
    addTime = json['add_time'];
    content = json['content'];
    id = json['id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['last_time'] = this.lastTime;
    data['add_time'] = this.addTime;
    data['content'] = this.content;
    data['id'] = this.id;
    data['status'] = this.status;
    return data;
  }
}


