class BaseModel {
  late String id; // ID objek model

  BaseModel({required this.id});

  BaseModel.fromJson(Map<String, dynamic> json) : id = json['_id'];

  Map<String, dynamic> toJson() => {'_id': id};
}
