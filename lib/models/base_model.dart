class BaseModel {
  late String id;

  BaseModel({required this.id});

  BaseModel.fromJson(Map<String, dynamic> json) : id = json['_id'];

  Map<String, dynamic> toJson() => {'_id': id};
}