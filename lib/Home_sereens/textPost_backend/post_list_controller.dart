import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'post_model.dart';

class PostListController extends GetxController {
  static PostListController get instance => Get.find();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get merged stream of text and media posts
  Stream<List<PostModel>> getPostsStream() {
    final textPostsStream = _firestore.collection('textPosts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => 
            PostModel.fromJson(doc.data())).toList());

    final mediaPostsStream = _firestore.collection('mediaPosts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => 
            PostModel.fromJson(doc.data())).toList());
    return CombineLatestStream.list<List<PostModel>>([
      textPostsStream,
      mediaPostsStream
    ]).map((listOfLists) {
      final textPosts = listOfLists[0];
      final mediaPosts = listOfLists[1];
      List<PostModel> allPosts = [...textPosts, ...mediaPosts];
      allPosts.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return allPosts;
    });
  }

  // Format timestamp to relative time
  String formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Just now';
    }
  }
}