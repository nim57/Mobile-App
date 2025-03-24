import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../../Utils/exceptions/firebase_exceptions.dart';
import '../../../../../Utils/exceptions/format_excptions.dart';
import '../../../../../Utils/exceptions/platform_exceptions.dart';
import 'item_model.dart';

class ItemRepository extends GetxController {
  static ItemRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<List<Item>> getAllItemsStream() {
    return _db.collection('items').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Item.fromSnapshot(doc)).toList());
  }

  /// Generate sequential item ID starting from 00000001
  Future<String> generateItemId() async {
    // Removed underscore to make public
    try {
      final counterDoc = await _db.collection('counters').doc('itemId').get();
      int currentCount = counterDoc.exists ? counterDoc.data()!['count'] : 0;
      currentCount++;
      final newId = currentCount.toString().padLeft(8, '0');

      await _db
          .collection('counters')
          .doc('itemId')
          .set({'count': currentCount});
      return newId;
    } on FirebaseException catch (e) {
      throw EFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw EFormatException('Format exception occurred');
    } on PlatformException catch (e) {
      throw EPlatformException(e.code).message;
    } catch (e) {
      throw 'Failed to generate item ID: ${e.toString()}';
    }
  }

  /// Save complete item to Firestore
  Future<void> saveItem(Item item) async {
    try {
      final itemId = await generateItemId();
      await _db.collection('items').doc(item.id).set({
        'categoryId': item.categoryId,
        'name': item.name,
        'tags': item.tags,
        'description': item.description,
        'email': item.email,
        'website': item.website,
        'phoneNumber': item.phoneNumber,
        'mapLocation': item.mapLocation,
        'profileImage': item.profileImage,
        'hasBranch': item.hasBranch,
        'createdAt': Timestamp.fromDate(item.createdAt),
        'updatedAt': Timestamp.fromDate(item.updatedAt),
      });
    } on FirebaseException catch (e) {
      throw EFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw EFormatException('Format exception occurred');
    } on PlatformException catch (e) {
      throw EPlatformException(e.code).message;
    } catch (e) {
      throw 'Failed to save item: ${e.toString()}';
    }
  }

  /// Fetch all items
  Future<List<Item>> getAllItems() async {
    try {
      final querySnapshot = await _db.collection('items').get();
      return querySnapshot.docs.map((doc) => Item.fromSnapshot(doc)).toList();
    } on FirebaseException catch (e) {
      throw EFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw EFormatException('Format exception occurred');
    } on PlatformException catch (e) {
      throw EPlatformException(e.code).message;
    } catch (e) {
      throw 'Failed to fetch items: ${e.toString()}';
    }
  }

  /// Get items by category ID
  Future<List<Item>> getItemsByCategory(String categoryId) async {
    try {
      final querySnapshot = await _db
          .collection('items')
          .where('categoryId', isEqualTo: categoryId)
          .get();
      return querySnapshot.docs.map((doc) => Item.fromSnapshot(doc)).toList();
    } on FirebaseException catch (e) {
      throw EFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw EFormatException('Format exception occurred');
    } on PlatformException catch (e) {
      throw EPlatformException(e.code).message;
    } catch (e) {
      throw 'Failed to fetch category items: ${e.toString()}';
    }
  }

  Future<void> updateItemFields({
    required String itemId,
    required Map<String, dynamic> fields,
  }) async {
    try {
      // Validate input
      if (itemId.isEmpty) throw 'Invalid item ID';
      if (fields.isEmpty) throw 'No fields to update';

      // Prepare update data
      final updateData = {
        ...fields,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Remove null values
      updateData.removeWhere((key, value) => value == null);

      // Perform update
      await _db.collection('items').doc(itemId).update(updateData);

      // Update local cache if needed
      final updatedItem = await getItemById(itemId);
      _db.collection('items').doc(itemId).update(updatedItem.toJson());
    } on FirebaseException catch (e) {
      throw EFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw EFormatException('Invalid data format');
    } on PlatformException catch (e) {
      throw EPlatformException(e.code).message;
    } catch (e) {
      throw 'Failed to update item: ${e.toString()}';
    }
  }

  /// Delete item
  Future<void> deleteItem(String itemId) async {
    try {
      await _db.collection('items').doc(itemId).delete();
    } on FirebaseException catch (e) {
      throw EFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw EFormatException('Format exception occurred');
    } on PlatformException catch (e) {
      throw EPlatformException(e.code).message;
    } catch (e) {
      throw 'Failed to delete item: ${e.toString()}';
    }
  }

  /// Upload item image to Firebase Storage
  Future<String> uploadItemImage(Uint8List imageBytes, String fileName) async {
    try {
      final Reference ref = _storage
          .ref()
          .child('item_images')
          .child('${DateTime.now().millisecondsSinceEpoch}_$fileName');

      final UploadTask uploadTask = ref.putData(
        imageBytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw EFirebaseException(e.code);
    } on FormatException catch (_) {
      throw EFormatException('Format exception occurred');
    } on PlatformException catch (e) {
      throw EPlatformException(e.code).message;
    } catch (e) {
      throw 'Image upload failed: ${e.toString()}';
    }
  }

  /// Get real-time stream of all items
  Stream<List<Item>> streamAllItems() {
    return _db.collection('items').snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((doc) => Item.fromSnapshot(doc)).toList());
  }

  // Update streamItemsByCategory with proper error handling
  Stream<List<Item>> streamItemsByCategory(String categoryId) {
    try {
      return _db
          .collection('items')
          .where('categoryId', isEqualTo: categoryId)
          .snapshots()
          .handleError((error) {
        throw EFirebaseException('Failed to stream items: $error');
      }).map((querySnapshot) =>
              querySnapshot.docs.map((doc) => Item.fromSnapshot(doc)).toList());
    } catch (e) {
      throw 'Failed to stream items: ${e.toString()}';
    }
  }

  /// Get available category IDs
  Future<List<String>> getCategoryIds() async {
    try {
      final querySnapshot = await _db.collection('categories').get();
      return querySnapshot.docs.map((doc) => doc.id).toList();
    } on FirebaseException catch (e) {
      throw EFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw EFormatException('Format exception occurred');
    } on PlatformException catch (e) {
      throw EPlatformException(e.code).message;
    } catch (e) {
      throw 'Failed to fetch category IDs: ${e.toString()}';
    }
  }

  /// Get item by ID
  Future<Item> getItemById(String itemId) async {
    try {
      final snapshot = await _db.collection('items').doc(itemId).get();
      if (snapshot.exists) {
        return Item.fromSnapshot(snapshot);
      } else {
        throw 'Item not found';
      }
    } on FirebaseException catch (e) {
      throw EFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw EFormatException('Format exception occurred');
    } on PlatformException catch (e) {
      throw EPlatformException(e.code).message;
    } catch (e) {
      throw 'Failed to fetch item: ${e.toString()}';
    }
  }
}
