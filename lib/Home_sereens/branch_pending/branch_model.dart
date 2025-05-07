import 'package:cloud_firestore/cloud_firestore.dart';

class BranchPending {
  final String id;
  final String categoryId;
  final String mainItemId;
  final String name;
  final List<String> tags;
  final String description;
  final String email;
  final String website;
  final String phone;
  final String mapLocation;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String requesterUserId;
  final String requesterEmail;

  BranchPending({
    required this.id,
    required this.categoryId,
    required this.mainItemId,
    required this.name,
    required this.tags,
    required this.description,
    required this.email,
    required this.website,
    required this.phone,
    required this.mapLocation,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.requesterUserId,
    required this.requesterEmail,
  });

  factory BranchPending.empty() => BranchPending(
        id: '',
        categoryId: '',
        mainItemId: '',
        name: '',
        tags: [],
        description: '',
        email: '',
        website: '',
        phone: '',
        mapLocation: '',
        imageUrl: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        requesterUserId: '',
        requesterEmail: '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'categoryId': categoryId,
        'mainItemId': mainItemId,
        'name': name,
        'tags': tags,
        'description': description,
        'email': email,
        'website': website,
        'phone': phone,
        'mapLocation': mapLocation,
        'imageUrl': imageUrl,
        'createdAt': Timestamp.fromDate(createdAt),
        'updatedAt': Timestamp.fromDate(updatedAt),
        'requesterUserId': requesterUserId,
        'requesterEmail': requesterEmail,
      };

  factory BranchPending.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return BranchPending(
      id: snapshot.id,
      categoryId: data['categoryId'] ?? '',
      mainItemId: data['mainItemId'] ?? '',
      name: data['name'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      description: data['description'] ?? '',
      email: data['email'] ?? '',
      website: data['website'] ?? '',
      phone: data['phone'] ?? '',
      mapLocation: data['mapLocation'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      requesterUserId: data['requesterUserId'] ?? '',
      requesterEmail: data['requesterEmail'] ?? '',
    );
  }
}