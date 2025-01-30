import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// Método para buscar os dados do usuário pelo ID
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Erro ao buscar dados do usuário: $e');
      return null;
    }
  }

  // Método para atualizar os dados do usuário
  Future<void> updateUserData(
      String userId, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection('users').doc(userId).update(updatedData);
      print('Dados do usuário atualizados com sucesso.');
    } catch (e) {
      print('Erro ao atualizar os dados do usuário: $e');
      throw Exception('Falha ao atualizar os dados.');
    }
  }

  // Check if a username exists
  Future<bool> doesUsernameExist(String username) async {
    final querySnapshot = await _firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  // Check if an email exists
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

  // Method to register a new user and create a subcollection
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

      // Add user data to Firestore and get the document reference
      DocumentReference userDocRef = await users.add({
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

      // Add a default workoutCards subcollection for the user
      await userDocRef.collection('workoutCards').add({
        'title': 'Default Workout',
        'subtitle': 'Sample Workout Plan',
        'exercises': [
          {
            'name': 'Push-up',
            'bodyPart': 'Chest',
            'equipment': 'Bodyweight',
            'gifUrl': 'https://example.com/pushup.gif',
          },
        ],
      });

      print('User registered successfully with a default workout card.');
    } catch (e) {
      print('Error registering user: $e');
      throw Exception('Failed to register user.');
    }
  }

  // Method to add a workout card for a user (needs valid userId)
  Future<void> addWorkoutCard(
      String userId, Map<String, dynamic> workoutCard) async {
    try {
      // Ensure userId is valid (not null or empty)
      if (userId.isEmpty) {
        throw Exception('Invalid userId');
      }

      // Get the user document reference based on userId
      DocumentReference userDocRef = _firestore.collection('users').doc(userId);

      // Add a workout card to the 'workoutCards' subcollection of the user
      await userDocRef.collection('workoutCards').add(workoutCard);
      print('Workout card added successfully for user $userId');
    } catch (e) {
      print('Error adding workout card: $e');
      throw Exception('Failed to add workout card');
    }
  }

  // Example method for fetching workout cards for a user
  Future<List<Map<String, dynamic>>> getWorkoutCards(String userId) async {
    try {
      // Ensure userId is valid (not null or empty)
      if (userId.isEmpty) {
        throw Exception('Invalid userId');
      }

      // Get the workoutCards subcollection for the user
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('workoutCards')
          .get();

      // Map each document in the subcollection to a Map
      List<Map<String, dynamic>> workoutCards = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      return workoutCards;
    } catch (e) {
      print('Error fetching workout cards: $e');
      throw Exception('Failed to fetch workout cards');
    }
  }

  Future<void> updateWorkoutCard(
      String userId, String cardId, Map<String, dynamic> updatedData) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('workoutCards')
          .doc(cardId)
          .set(updatedData, SetOptions(merge: true));
      print('Workout card updated successfully.');
    } catch (e) {
      print('Error updating workout card: $e');
      throw Exception('Failed to update workout card.');
    }
  }

  Future<void> deleteWorkoutCard(String userId, String cardId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('workoutCards')
          .doc(cardId)
          .delete();
      print('Workout card deleted successfully.');
    } catch (e) {
      print('Error deleting workout card: $e');
      throw Exception('Failed to delete workout card.');
    }
  }

  Future<Map<String, dynamic>?> getWorkoutCardByTitle(
      String userId, String title) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('workoutCards')
          .where('title', isEqualTo: title)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        return {
          'id': doc.id, // Document ID
          'data': doc.data(),
        };
      }
      return null;
    } catch (e) {
      print('Error fetching workout card by title: $e');
      return null;
    }
  }

// Update the user's selected plan
  Future<void> updateUserPlan(String userId, String plan) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'plan': plan, // Update the plan field
      });
      print('User plan updated successfully.');
    } catch (e) {
      print('Error updating user plan: $e');
      throw Exception('Failed to update plan.');
    }
  }
}
