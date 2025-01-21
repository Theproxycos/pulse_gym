import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> doesUsernameExist(String username) async {
    final querySnapshot = await _firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<bool> emailExists(String email) async {
    try {
      var querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Error checking email: $e');
    }
  }

  // Method to register a new user
  Future<void> registerUser({
    required String username,
    required String phoneNumber,
    required String email,
    required String gender,
    required String dateOfBirth,
    required String password,
    required String address,
    required String country,
  }) async {
    try {
      // Reference to the 'users' collection
      CollectionReference users = _firestore.collection('users');
      // Add user data to Firestore
      await users.add({
        'username': username,
        'phone_number': phoneNumber,
        'email': email,
        'gender': gender,
        'date_of_birth': dateOfBirth,
        'password': password, // Consider encrypting passwords in production
        'address': address,
        'country': country,
        'created_at': FieldValue.serverTimestamp(),
      });

      print('User registered successfully.');
    } catch (e) {
      print('Error registering user: $e');
      throw Exception('Failed to register user.');
    }
  }
}
