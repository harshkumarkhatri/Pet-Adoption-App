class PetModel {
  String? name;
  String? age;
  double? price;
  String? imageUrl;
  bool? isAdopted;
  String? gender;
  String? color;
  String? type;
  String? description;
  Owner? owner;

  PetModel(
      {this.name,
      this.age,
      this.price,
      this.imageUrl,
      this.isAdopted,
      this.gender,
      this.type,
      this.color,
      this.description,
      this.owner});

  PetModel.fromJson(Map<dynamic, dynamic> json) {
    name = json['name'];
    age = json['age'];
    price = json['price'];
    imageUrl = json['image_url'];
    isAdopted = json['is_adopted'];
    gender = json['gender'];
    type = json['type'];
    color = json['color'];
    description = json['description'];
    owner = json['owner'] != null ? Owner.fromJson(json['owner']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['age'] = age;
    data['price'] = price;
    data['image_url'] = imageUrl;
    data['is_adopted'] = isAdopted;
    data['gender'] = gender;
    data['color'] = color;
    data['type'] = type;
    data['description'] = description;
    if (owner != null) {
      data['owner'] = owner?.toJson();
    }
    return data;
  }
}

class Owner {
  String? name;
  String? imageUrl;

  Owner({this.name, this.imageUrl});

  Owner.fromJson(Map<dynamic, dynamic> json) {
    name = json['name'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['image_url'] = imageUrl;
    return data;
  }
}
