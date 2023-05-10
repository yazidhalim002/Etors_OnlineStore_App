import 'dart:ffi';

class Product {
  late String name, description, image, price, color, size, uid;
  late int sold;

  Product({
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.size,
    required this.color,
    required this.sold,
    required this.uid,
  });

  Product.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) {
      return;
    }
    name = map['name'];
    description = map['description'];
    image = map['image'];
    price = map['price'];
    color = map['color'];
    size = map['size'];
    sold = map['sold'];
    uid = map['uid'];
    ;
  }

  toJson() {
    return {
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'color': color,
      'size': size,
      'sold': sold,
      'uid': uid,
    };
  }
}
