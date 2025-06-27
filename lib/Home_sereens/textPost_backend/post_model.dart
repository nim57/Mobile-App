enum PostType { text, media }

class PostModel {
  final String userId;
  final String userName;
  final String userProfilePic;
  final String description;
  final DateTime timestamp;
  final PostType type;
  
  // Text-specific fields
  final String? textContent;
  final String? backgroundColor;
  final String? textStyle;
  
  // Media-specific fields
  final List<String>? mediaUrls;
  final List<String>? mediaTypes;

  PostModel({
    required this.userId,
    required this.userName,
    required this.userProfilePic,
    required this.description,
    required this.timestamp,
    required this.type,
    this.textContent,
    this.backgroundColor,
    this.textStyle,
    this.mediaUrls,
    this.mediaTypes,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'userProfilePic': userProfilePic,
      'description': description,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'type': type.name,
      'textContent': textContent,
      'backgroundColor': backgroundColor,
      'textStyle': textStyle,
      'mediaUrls': mediaUrls,
      'mediaTypes': mediaTypes,
    };
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      userId: json['userId'],
      userName: json['userName'],
      userProfilePic: json['userProfilePic'],
      description: json['description'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      type: PostType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => PostType.text,
      ),
      textContent: json['textContent'],
      backgroundColor: json['backgroundColor'],
      textStyle: json['textStyle'],
      mediaUrls: json['mediaUrls'] != null 
          ? List<String>.from(json['mediaUrls']) 
          : null,
      mediaTypes: json['mediaTypes'] != null 
          ? List<String>.from(json['mediaTypes']) 
          : null,
    );
  }
}