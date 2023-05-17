import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Product {
  int id;
  String price;
  String size;
  String color;
  String category;
  String description;
  String image;
  String name;
  int sold;
  String uid;

  Product({
    required this.id,
    required this.price,
    required this.size,
    required this.color,
    required this.category,
    required this.description,
    required this.image,
    required this.name,
    required this.sold,
    required this.uid,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<dynamic, dynamic> data = doc.data() as Map<dynamic, dynamic>;
    return Product(
      id: data['id'],
      price: data['price'],
      size: data['size'],
      color: data['color'],
      category: data['category'],
      description: data['description'],
      image: data['image'],
      name: data['name'],
      sold: data['sold'],
      uid: data['uid'],
    );
  }

  static List<Product> fromQuerySnapshot(
      List<QueryDocumentSnapshot> documents) {
    return documents.map((doc) => Product.fromFirestore(doc)).toList();
  }
}
