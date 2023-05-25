import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String id;
  final String userType;
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String uid;
  final Map<String, dynamic> address;
  final String image;
  final double balance;
  final bool available;

  Users({
    required this.id,
    required this.userType,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.uid,
    required this.address,
    required this.image,
    required this.balance,
    required this.available,
  });

  factory Users.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Users(
      id: snapshot.id,
      userType: data['Type'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      email: data['Email'],
      username: data['Username'],
      uid: data['uid'],
      address: Map<String, dynamic>.from(data['Address'] ?? []),
      image: data['image'],
      balance: data['balance']?.toDouble() ?? 0.0,
      available: data['available'] ?? false,
    );
  }

  static Future<Users?> getUserFromFirestore(String userId) async {
    try {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        return Users.fromDocumentSnapshot(snapshot);
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
    return null;
  }
}
