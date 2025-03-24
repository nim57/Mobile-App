import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id;
  final String name;
  final String log;

  const Category({
    required this.id,
    required this.name,
    required this.log,
  });

  // Empty category model
  const Category.empty()
      : id = '',
        name = '',
        log = '';

  // Convert model to JSON for Firebase
  Map<String, dynamic> toJson() {
    try {
      return {
        'id': id,
        'name': name,
        'log': log,
      };
    } catch (e) {
      throw _ConversionException('Error converting Category to JSON: $e');
    }
  }

  // Create Category from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    try {
      return Category(
        id: _validateStringField(json['id'], 'id'),
        name: _validateStringField(json['name'], 'name'),
        log: _validateStringField(json['log'], 'log'),
      );
    } catch (e) {
      throw _ConversionException('Error creating Category from JSON: $e');
    }
  }

   // Create Category from Firestore DocumentSnapshot
  factory Category.fromSnapshot(DocumentSnapshot snapshot) {
    try {
      if (!snapshot.exists) {
        throw const FormatException('Document does not exist');
      }
      
      final data = snapshot.data() as Map<String, dynamic>;
      return Category(
        id: snapshot.id, // Get ID from document reference
        name: _validateStringField(data['name'], 'name'),
        log: _validateStringField(data['log'], 'log'),
      );
    } on FormatException catch (e) {
      throw _ConversionException('Firestore format error: ${e.message}');
    } catch (e) {
      throw _ConversionException('Error creating Category from snapshot: $e');
    }
  }


  // Helper method for field validation
  static String _validateStringField(dynamic value, String fieldName) {
    if (value == null) {
      throw FormatException('Missing required field: $fieldName');
    }
    if (value is! String) {
      throw FormatException('Invalid type for field $fieldName. Expected String');
    }
    return value;
  }

  // Copy with method for immutability
  Category copyWith({
    String? id,
    String? name,
    String? log,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      log: log ?? this.log,
    );
  }

  @override
  String toString() => 'Category(id: $id, name: $name, log: $log)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          log == other.log;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ log.hashCode;
}

class _ConversionException implements Exception {
  final String message;
  const _ConversionException(this.message);
  @override
  String toString() => 'CategoryConversionException: $message';
} 