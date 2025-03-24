// pending_item_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class PendingItem {
  final String id;
  final String categoryId;
  final String name;
  final List<String> tags;
  final String description;
  final String email;
  final String website;
  final String phone;
  final String mapLocation;
  final String imageUrl;
  final bool hasBranch;
  final DateTime createdAt;
  final DateTime updatedAt;
   final String requesterUserId; // Add this
  final String requesterEmail;  

  PendingItem({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.tags,
    required this.description,
    required this.email,
    required this.website,
    required this.phone,
    required this.mapLocation,
    required this.imageUrl,
    required this.hasBranch,
    required this.createdAt,
    required this.updatedAt,
    required this.requesterUserId, // Add this
    required this.requesterEmail,
  });

  factory PendingItem.empty() => PendingItem(
        id: '',
        categoryId: '',
        name: '',
        tags: [],
        description: '',
        email: '',
        website: '',
        phone: '',
        mapLocation: '',
        imageUrl: '',
        hasBranch: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        requesterUserId: '', // Add this
        requesterEmail: '', 
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'categoryId': categoryId,
        'name': name,
        'tags': tags,
        'description': description,
        'email': email,
        'website': website,
        'phone': phone,
        'mapLocation': mapLocation,
        'imageUrl': imageUrl,
        'hasBranch': hasBranch,
        'createdAt': Timestamp.fromDate(createdAt),
        'updatedAt': Timestamp.fromDate(updatedAt),
         'requesterUserId': requesterUserId, // Add this
        'requesterEmail': requesterEmail,
      };

  factory PendingItem.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return PendingItem(
      id: snapshot.id,
      categoryId: data['categoryId'] ?? '',
      name: data['name'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      description: data['description'] ?? '',
      email: data['email'] ?? '',
      website: data['website'] ?? '',
      phone: data['phone'] ?? '',
      mapLocation: data['mapLocation'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      hasBranch: data['hasBranch'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      requesterUserId: data['requesterUserId'] ?? '', // Add this
      requesterEmail: data['requesterEmail'] ?? '', 
    );
  }
}