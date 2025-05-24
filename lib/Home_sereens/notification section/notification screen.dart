// user_app/notification_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        // ... [App bar code from original]
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

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
                onTap: () => _showNotificationDetails(context, notification),
              );
            },
          );
        },
      ),
    );
  }

  void _showNotificationDetails(BuildContext context, Map<String, dynamic> notification) {
    showModalBottomSheet(
      context: context,
      builder: (context) => NotificationDetailSheet(notification: notification),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final Map<String, dynamic> notification;
  final DateTime timestamp;
  final VoidCallback onTap;

  const NotificationTile({
    required this.notification,
    required this.timestamp,
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
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(notification['description'] ?? ''),
          const SizedBox(height: 4),
          Text(
            DateFormat('MMM dd, yyyy - hh:mm a').format(timestamp),
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
      trailing: notification['read'] ?? false 
          ? null 
          : const Icon(Icons.circle, color: Colors.blue, size: 12),
    );
  }
}

class NotificationDetailSheet extends StatelessWidget {
  final Map<String, dynamic> notification;

  const NotificationDetailSheet({required this.notification, super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notification['title'],
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          if (notification['mediaPath'] != null)
            notification['mediaType'] == 'image'
                ? Image.network(notification['mediaPath'])
                : const Icon(Icons.videocam, size: 100),
          const SizedBox(height: 16),
          Text(notification['description']),
          if (notification['url'] != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _launchUrl(notification['url']),
              child: const Text('Open Link'),
            ),
          ],
          const SizedBox(height: 16),
          Text(
            'Received: ${DateFormat("MMM dd, yyyy - hh:mm a").format(
              (notification['timestamp'] as Timestamp).toDate(),
            )}',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}