import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  PrivacyPolicyPage({super.key});

  final List<PolicySection> sections = [
    /// introduction
    PolicySection(title: 'What is the Echo ?', content: '''
Welcome to Echo, your trusted platform for sharing and discovering authentic reviews. This Privacy Policy explains how we collect, use, and safeguard your information when you use the Echo mobile app and related services. By using Echo, you agree to the practices described below. This policy applies to all features, including anonymous reviews, replies, content moderation, and account management.
    '''),

    /// Information collection
    PolicySection(
      title: 'What information do we collect?',
      content: '''
To provide a safe and seamless experience, Echo collects the following data:

> Personal Information

 • Email address, username, and profile details (for registered accounts).

 • Optional: Profile picture or social media links (if you choose to add them).

> Non-Personal Information

 • Device details (model, OS version), IP address, app usage patterns (e.g., time spent, features used), and diagnostic logs.

 • Anonymous activity data (e.g., reviews, replies posted without linking to your account).

> User-Generated Content

 • Reviews, replies, and images you post (even anonymously).

Note: Echo does not collect payment details, health data, or precise location.
''',
    ),

    /// How we collect information
    PolicySection(
      title: 'How we collect information?',
      content: '''
Directly From You
• When you register, post reviews, reply to others, or contact support.
• When you enable permissions (e.g., camera for uploading images).

Automatically
• Via Firebase Analytics and Crashlytics for app performance monitoring.
• Device identifiers (e.g., Android ID) for fake account detection.

Third Parties
• Firebase (Google’s backend service) for data storage and authentication.
''',
    ),

    /// How We Use Your Information
    PolicySection(
      title: 'How We Use Your Information',
      content: '''
Your data helps us:
• Operate the app (e.g., display reviews, manage accounts).
• Moderate content using automated hate speech detection and fake account prevention systems.
• Improve app features and fix bugs (e.g., via usage analytics).
• Send critical updates (e.g., security alerts, policy changes).
• Protect users and comply with laws (e.g., investigating abuse).
''',
    ),

    /// Data Sharing & Disclosure
    PolicySection(
      title: 'Data Sharing & Disclosure',
      content: '''
We only share data when necessary:
• Service Providers: Firebase (hosting, analytics) and AI moderation tools (for hate speech detection).
• Legal Obligations: To comply with court orders or protect Echo’s rights.
• Anonymous Content: Publicly shared reviews/replies (no personal identifiers).
We never sell your data.
''',
    ),

    /// Data Security
    PolicySection(
      title: 'Data Security',
      content: '''
Echo uses industry-standard measures to protect your information:
• Firebase Security: Data encrypted in transit and at rest.
• Access Controls: Restricted to authorized team members.
• Anonymity: Posts marked “anonymous” are stored without linking to your account.
While we strive to protect your data, no system is 100% secure.
''',
    ),

    /// Your Rights
    PolicySection(
      title: 'Your Rights',
      content: '''
You can:
• Access, update, or delete your account via app settings.
• Request a copy of your data or withdraw consent (email: nimeshsandaruwan2682gmail.com.com).
• Opt out of non-essential communications (e.g., promotional emails).
''',
    ),

    /// Third-Party Links
    PolicySection(
      title: 'Third-Party Links',
      content: '''
Echo may link to external websites (e.g., business websites in reviews). We are not responsible for their privacy practices.
''',
    ),

    /// Children’s Privacy
    PolicySection(
      title: 'Children’s Privacy',
      content: '''
Echo is not intended for users under 13. We do not knowingly collect data from children.
''',
    ),

    /// Policy Updates
    PolicySection(
      title: 'Policy Updates',
      content: '''
We’ll notify you of changes via in-app alerts or email. Continued use after updates implies acceptance.''',
    ),

    /// Contact Us
    PolicySection(
      title: 'Contact Us',
      content: '''
Questions? Reach our privacy team at nimeshsandaruwan268@gmail.com.com.''',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Privacy Policy',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Explore the policy',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Effective ${DateTime.now().toString().split(' ')[0]}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sections.length,
              itemBuilder: (context, index) {
                return PolicySectionWidget(section: sections[index]);
              },
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 17),
                  const Text(
                    'Thank you for trusting Echo!',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  Text('Transparency and safety drive everything we build.'),
                  const SizedBox(height: 16),
                  const Text(
                    'Other policies',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildPolicyLink('Terms of Service'),
                  const SizedBox(height: 12),
                  _buildPolicyLink('Cookies policy'),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyLink(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
        const Icon(
          Icons.open_in_new,
          size: 20,
          color: Colors.red,
        ),
      ],
    );
  }
}

class PolicySection {
  final String title;
  final String content;

  PolicySection({
    required this.title,
    required this.content,
  });
}

class PolicySectionWidget extends StatefulWidget {
  final PolicySection section;

  const PolicySectionWidget({
    super.key,
    required this.section,
  });

  @override
  State<PolicySectionWidget> createState() => _PolicySectionWidgetState();
}

class _PolicySectionWidgetState extends State<PolicySectionWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.section.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded)
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
            child: Text(
              widget.section.content,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        const Divider(height: 1),
      ],
    );
  }
}
