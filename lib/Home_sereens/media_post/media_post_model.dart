// class MediaPostModel {
//   final String userId;
//   final String userName;
//   final String userProfilePic;
//   final String description;
//   final List<String> mediaUrls;
//   final List<String> mediaTypes; // 'image' or 'video'
//   final DateTime timestamp;

//   MediaPostModel({
//     required this.userId,
//     required this.userName,
//     required this.userProfilePic,
//     required this.description,
//     required this.mediaUrls,
//     required this.mediaTypes,
//     required this.timestamp,
//   });

//   // Convert to JSON for Firebase
//   Map<String, dynamic> toJson() {
//     return {
//       'userId': userId,
//       'userName': userName,
//       'userProfilePic': userProfilePic,
//       'description': description,
//       'mediaUrls': mediaUrls,
//       'mediaTypes': mediaTypes,
//       'timestamp': timestamp.millisecondsSinceEpoch,
//     };
//   }

//   // Create from JSON
//   factory MediaPostModel.fromJson(Map<String, dynamic> json) {
//     return MediaPostModel(
//       userId: json['userId'],
//       userName: json['userName'],
//       userProfilePic: json['userProfilePic'],
//       description: json['description'],
//       mediaUrls: List<String>.from(json['mediaUrls']),
//       mediaTypes: List<String>.from(json['mediaTypes']),
//       timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
//     );
//   }
// }