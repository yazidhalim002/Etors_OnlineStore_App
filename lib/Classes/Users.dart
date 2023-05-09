import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class users {
  late String Email, Username, Firstname, Lastname, Type;

  users(this.Email, this.Username, this.Firstname, this.Lastname, this.Type);

  users.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) {
      return;
    }
    Email = map['Email'];
    Username = map['Username'];
    Firstname = map['Firstname'];
    Lastname = map['Lastname'];
    Type = map['Type'];
  }

  toJson() {
    return {
      'Email': Email,
      'Username': Username,
      'Firstname': Firstname,
      'Lastname': Lastname,
      'Type': Type
    };
  }

  final CollectionReference _usercollectionReference =
      FirebaseFirestore.instance.collection('users');
  final user = FirebaseAuth.instance.currentUser!.email;
  Future<String?> getType() async {
    try {
      QuerySnapshot querySnapshot =
          await _usercollectionReference.where('Email', isEqualTo: user).get();
      if (querySnapshot.size > 0) {
        for (var doc in querySnapshot.docs) {
          return doc['Type'];
        }
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
