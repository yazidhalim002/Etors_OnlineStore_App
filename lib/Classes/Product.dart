import 'dart:ffi';

class Product {
  late String name, description, image, price, color, size;

  Product(
      {required this.name,
      required this.description,
      required this.image,
      required this.price,
      required this.size,
      required this.color});

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
  }

  toJson() {
    return {
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'color': color,
      'size': size,
    };
  }
}
