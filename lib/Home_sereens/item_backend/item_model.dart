import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String id;
  final String categoryId;
  final String name;
  final List<String> tags;
  final String description;
  final String email;
  final String website;
  final String phoneNumber;
  final String mapLocation;
  final String profileImage;
  final bool hasBranch;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Item({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.tags,
    required this.description,
    required this.email,
    required this.website,
    required this.phoneNumber,
    required this.mapLocation,
    required this.profileImage,
    required this.hasBranch,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Empty item model
  factory Item.empty() => Item(
        id: '',
        categoryId: '',
        name: '',
        tags: const [],
        description: '',
        email: '',
        website: '',
        phoneNumber: '',
        mapLocation: '',
        profileImage: '',
        hasBranch: false,
        createdAt: DateTime(1970),
        updatedAt: DateTime(1970),
      );

  /// Convert model to JSON for Firebase
  Map<String, dynamic> toJson() {
    try {
      return {
        'id': id,
        'categoryId': categoryId,
        'name': name,
        'tags': tags,
        'description': description,
        'email': email,
        'website': website,
        'phoneNumber': phoneNumber,
        'mapLocation': mapLocation,
        'profileImage': profileImage,
        'hasBranch': hasBranch,
        'createdAt': Timestamp.fromDate(createdAt),
        'updatedAt': Timestamp.fromDate(updatedAt),
      };
    } catch (e) {
      throw _ConversionException('Error converting Item to JSON: $e');
    }
  }

  /// Create Item from JSON
  factory Item.fromJson(Map<String, dynamic> json) {
    try {
      return Item(
        id: _validateStringField(json['id'], 'id'),
        categoryId: _validateStringField(json['categoryId'], 'categoryId'),
        name: _validateStringField(json['name'], 'name'),
        tags: _validateTagsList(json['tags']),
        description: _validateStringField(json['description'], 'description'),
        email: _validateEmail(json['email']),
        website: _validateWebsite(json['website']),
        phoneNumber: _validatePhoneNumber(json['phoneNumber']),
        mapLocation: _validateStringField(json['mapLocation'], 'mapLocation'),
        profileImage:
            _validateStringField(json['profileImage'], 'profileImage'),
        hasBranch: _validateBoolField(json['hasBranch'], 'hasBranch'),
        createdAt: _validateTimestampField(json['createdAt'], 'createdAt'),
        updatedAt: _validateTimestampField(json['updatedAt'], 'updatedAt'),
      );
    } catch (e) {
      throw _ConversionException('Error creating Item from JSON: $e');
    }
  }

  factory Item.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Item(
      id: snapshot.id,
      categoryId: data['categoryId'] ?? '',
      name: data['name'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      description: data['description'] ?? '',
      email: data['email'] ?? '',
      website: data['website'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      mapLocation: data['mapLocation'] ?? '',
      profileImage: data['profileImage'] ?? '',
      hasBranch: data['hasBranch'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  /// Copy with method for immutability
  Item copyWith({
    String? id,
    String? categoryId,
    String? name,
    List<String>? tags,
    String? description,
    String? email,
    String? website,
    String? phoneNumber,
    String? mapLocation,
    String? profileImage,
    bool? hasBranch,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Item(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      tags: tags ?? this.tags,
      description: description ?? this.description,
      email: email ?? this.email,
      website: website ?? this.website,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      mapLocation: mapLocation ?? this.mapLocation,
      profileImage: profileImage ?? this.profileImage,
      hasBranch: hasBranch ?? this.hasBranch,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Validation methods
  static String _validateStringField(dynamic value, String fieldName) {
    if (value == null) {
      throw FormatException('Missing required field: $fieldName');
    }
    if (value is! String) {
      throw FormatException(
          'Invalid type for field $fieldName. Expected String');
    }
    return value;
  }

  static List<String> _validateTagsList(dynamic value) {
    if (value == null) return [];
    if (value is! List) {
      throw FormatException('Invalid type for field tags. Expected List');
    }
    return List<String>.from(value.map((e) => e.toString()));
  }

  static bool _validateBoolField(dynamic value, String fieldName) {
    if (value == null) return false;
    if (value is! bool) {
      throw FormatException('Invalid type for field $fieldName. Expected bool');
    }
    return value;
  }

  static String _validateEmail(String value) {
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      throw FormatException('Invalid email format');
    }
    return value;
  }

  static String _validateWebsite(String value) {
    if (!RegExp(r'^(http|https):\/\/[^ "]+$').hasMatch(value)) {
      throw FormatException('Invalid website URL format');
    }
    return value;
  }

  static String _validatePhoneNumber(String value) {
    if (!RegExp(r'^\+?[0-9]{8,15}$').hasMatch(value)) {
      throw FormatException('Invalid phone number format');
    }
    return value;
  }

  static DateTime _validateTimestampField(dynamic value, String fieldName) {
    if (value == null) {
      throw FormatException('Missing required field: $fieldName');
    }
    if (value is! Timestamp) {
      throw FormatException(
          'Invalid type for field $fieldName. Expected Timestamp');
    }
    return value.toDate();
  }

  @override
  String toString() => 'Item('
      'id: $id, '
      'categoryId: $categoryId, '
      'name: $name, '
      'tags: $tags, '
      'description: $description, '
      'email: $email, '
      'website: $website, '
      'phoneNumber: $phoneNumber, '
      'mapLocation: $mapLocation, '
      'profileImage: $profileImage, '
      'hasBranch: $hasBranch, '
      'createdAt: $createdAt, '
      'updatedAt: $updatedAt'
      ')';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Item &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          categoryId == other.categoryId &&
          name == other.name &&
          tags == other.tags &&
          description == other.description &&
          email == other.email &&
          website == other.website &&
          phoneNumber == other.phoneNumber &&
          mapLocation == other.mapLocation &&
          profileImage == other.profileImage &&
          hasBranch == other.hasBranch &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      categoryId.hashCode ^
      name.hashCode ^
      tags.hashCode ^
      description.hashCode ^
      email.hashCode ^
      website.hashCode ^
      phoneNumber.hashCode ^
      mapLocation.hashCode ^
      profileImage.hashCode ^
      hasBranch.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}

class _ConversionException implements Exception {
  final String message;
  const _ConversionException(this.message);
  @override
  String toString() => 'ItemConversionException: $message';
}
