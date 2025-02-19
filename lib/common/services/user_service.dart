import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:beehive/global.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Future<void> deleteUserAccount() async {
    final userId = Global.storageService.getUserProfile().id;
    if (userId == null) {
      throw Exception('User ID not found');
    }

    // Delete user's messages
    final messagesToDelete = await _db.collection("message")
        .where("from_token", isEqualTo: userId)
        .get();
    
    for (var doc in messagesToDelete.docs) {
      await doc.reference.delete();
    }

    final messagesToDelete2 = await _db.collection("message")
        .where("to_token", isEqualTo: userId)
        .get();
    
    for (var doc in messagesToDelete2.docs) {
      await doc.reference.delete();
    }

    // Delete user's calls
    final callsToDelete = await _db.collection("calls")
        .where("from_token", isEqualTo: userId)
        .get();
    
    for (var doc in callsToDelete.docs) {
      await doc.reference.delete();
    }

    final callsToDelete2 = await _db.collection("calls")
        .where("to_token", isEqualTo: userId)
        .get();
    
    for (var doc in callsToDelete2.docs) {
      await doc.reference.delete();
    }

    // Delete user's profile
    await _db.collection("users")
        .doc(userId)
        .delete();
  }
}
