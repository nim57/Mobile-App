import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'branch_model.dart';

class BranchRepository extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadBranchImage(Uint8List imageBytes) async {
    try {
      final ref = _storage.ref()
        .child('branch_images/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = ref.putData(imageBytes);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw 'Image upload failed: ${e.toString()}';
    }
  }

  Future<String> generateBranchId() async {
    final counterRef = _firestore.collection('counters').doc('branch_id');
    return _firestore.runTransaction<String>((transaction) async {
      final snapshot = await transaction.get(counterRef);
      int count = snapshot.exists ? snapshot.data()!['count'] : 0;
      count++;
      transaction.set(counterRef, {'count': count});
      return count.toString().padLeft(8, '0');
    });
  }

  Future<void> saveBranchPending(BranchPending branch) async {
    try {
      await _firestore.collection('pending_branches')
        .doc(branch.id)
        .set(branch.toJson());
    } catch (e) {
      throw 'Failed to save branch: ${e.toString()}';
    }
  }
}