// user_app/notification_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        elevation: 2,
      ),
      body: NotificationList(),
    );
  }
}

class NotificationList extends StatelessWidget {
  const NotificationList({super.key});

  // Update notification read status in Firestore
  Future<void> _markAsRead(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(docId)
          .update({'read': true});
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        // Handle errors
        if (snapshot.hasError) {
          return Center(child: Text('Error loading notifications: ${snapshot.error}'));
        }

        // Show loading indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Get notifications documents
        final notifications = snapshot.data!.docs;

        return ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final doc = notifications[index];
            final notification = doc.data() as Map<String, dynamic>;
            final timestamp = (notification['timestamp'] as Timestamp).toDate();

            return NotificationTile(
              notification: notification,
              timestamp: timestamp,
              docId: doc.id,
              onTap: () {
                // Mark as read when opened
                if (!(notification['read'] ?? false)) {
                  _markAsRead(doc.id);
                }
                // Navigate to detail screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationDetailsScreen(
                      notification: notification,
                      timestamp: timestamp,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class NotificationTile extends StatelessWidget {
  final Map<String, dynamic> notification;
  final DateTime timestamp;
  final String docId;
  final VoidCallback onTap;

  const NotificationTile({
    required this.notification,
    required this.timestamp,
    required this.docId,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: const Icon(Icons.notifications, color: Colors.blue),
      title: Text(
        notification['title'] ?? 'No Title',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: notification['read'] ?? false ? Colors.grey : Colors.black,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(notification['description'] ?? 'No Description'),
          const SizedBox(height: 4),
          Text(
            DateFormat('MMM dd, yyyy - hh:mm a').format(timestamp),
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
      // Show unread indicator only if not read
      trailing: (notification['read'] ?? false)
          ? null
          : const Icon(Icons.circle, color: Colors.blue, size: 12),
    );
  }
}

class NotificationDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> notification;
  final DateTime timestamp;

  const NotificationDetailsScreen({
    required this.notification,
    required this.timestamp,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(notification['title'] ?? 'Notification Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // White container with content
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    notification['title'] ?? 'No Title',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 20),

                  // Media content
                  if (notification['mediaPath'] != null)
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[200],
                      ),
                      child: notification['mediaType'] == 'image'
                          ? Image.network(
                              notification['mediaPath'],
                              fit: BoxFit.cover,
                            )
                          : const Center(
                              child: Icon(Icons.videocam, size: 50),
                            ),
                    ),
                  const SizedBox(height: 20),

                  // Description
                  Text(
                    notification['description'] ?? 'No Description',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),

                  // URL Button if available
                  if (notification['url'] != null &&
                      notification['url'].toString().isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () => _launchUrl(notification['url']),
                        child: const Text('OPEN RELATED LINK'),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Timestamp
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Received: ${DateFormat("MMM dd, yyyy - hh:mm a").format(timestamp)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        debugPrint('Could not launch $url');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }
}