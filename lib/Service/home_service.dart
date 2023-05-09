import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeService extends GetxController {
  final CollectionReference _productCollectionRef =
      FirebaseFirestore.instance.collection('Products');

  Future<List<QueryDocumentSnapshot>> getProduct() async {
    var value = await _productCollectionRef.get();
    return value.docs;
  }
}
