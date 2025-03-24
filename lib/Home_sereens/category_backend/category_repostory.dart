import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../../Utils/exceptions/firebase_exceptions.dart';
import '../../../../../Utils/exceptions/format_excptions.dart';
import '../../../../../Utils/exceptions/platform_exceptions.dart';
import 'category_model.dart';
// Assuming your Category model is here

class CategoryRepository extends GetxController {
  static CategoryRepository get instance => Get.find();

  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  /// Save category to Firestore
  Future<void> saveCategory(Category category) async {
    try {
      await db.collection('categories').doc(category.id).set(category.toJson());
    } on FirebaseException catch (e) {
      throw EFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw EFormatException('Format exception occurred');
    } on PlatformException catch (e) {
      throw EPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong while saving category';
    }
  }

  /// Fetch single category by ID
  Future<Category> getCategoryById(String categoryId) async {
    try {
      final snapshot = await db.collection('categories').doc(categoryId).get();
      if (snapshot.exists) {
        return Category.fromSnapshot(snapshot);
      } else {
        return Category.empty();
      }
    } on FirebaseException catch (e) {
      throw EFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw EFormatException('Format exception occurred');
    } on PlatformException catch (e) {
      throw EPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong while fetching category';
    }
  }

  /// Fetch all categories
  Future<List<Category>> getAllCategories() async {
    try {
      final querySnapshot = await db.collection('categories').get();
      return querySnapshot.docs
          .map((doc) => Category.fromSnapshot(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw EFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw EFormatException('Format exception occurred');
    } on PlatformException catch (e) {
      throw EPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong while fetching categories';
    }
  }

  /// Update category details
  Future<void> updateCategory(Category updatedCategory) async {
    try {
      await db
          .collection('categories')
          .doc(updatedCategory.id)
          .update(updatedCategory.toJson());
    } on FirebaseException catch (e) {
      throw EFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw EFormatException('Format exception occurred');
    } on PlatformException catch (e) {
      throw EPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong while updating category';
    }
  }

  /// Delete category
  Future<void> deleteCategory(String categoryId) async {
    try {
      await db.collection('categories').doc(categoryId).delete();
    } on FirebaseException catch (e) {
      throw EFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw EFormatException('Format exception occurred');
    } on PlatformException catch (e) {
      throw EPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong while deleting category';
    }
  }

  /// Real-time stream of categories
  Stream<List<Category>> streamAllCategories() {
    return db.collection('categories').snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((doc) => Category.fromSnapshot(doc)).toList());
  }

  /// Upload category image
  Future<String> uploadCategoryImage(
    Uint8List imageBytes, {
    required String fileName,
  }) async {
    try {
      final Reference ref = storage
          .ref()
          .child('category_images')
          .child('${DateTime.now().millisecondsSinceEpoch}_$fileName');

      final UploadTask uploadTask = ref.putData(
        imageBytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw EFirebaseException(e.code);
    } catch (e) {
      throw Exception('Image upload failed: ${e.toString()}');
    }
  }

  /// Update specific category fields
  Future<void> updateCategoryFields({
    required String categoryId,
    required Map<String, dynamic> fields,
  }) async {
    try {
      await db.collection('categories').doc(categoryId).update(fields);
    } on FirebaseException catch (e) {
      throw EFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw EFormatException('Format exception occurred');
    } on PlatformException catch (e) {
      throw EPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong while updating category fields';
    }
  }
}
