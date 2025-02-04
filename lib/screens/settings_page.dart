import 'package:flutter/material.dart';
import '../screens/subscription_page.dart';
import 'login.dart';

class SettingsPage extends StatelessWidget {
  final String userId; // Parâmetro userId

  const SettingsPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.orange)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildButton(
              context,
              label: 'Subscription Plan',
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubscriptionPage(userId: userId),
                  ),
                );
                if (result != null) {}
              },
            ),
            _buildButton(
              context,
              label: 'Change Theme',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Choose Theme'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: const Text('Light Theme'),
                            onTap: () {},
                          ),
                          ListTile(
                            title: const Text('Dark Theme'),
                            onTap: () {},
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            _buildButton(
              context,
              label: 'FAQs',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FAQsPage()),
                );
              },
            ),
            _buildButton(
              context,
              label: 'Contact us',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ContactPage()),
                );
              },
            ),
            _buildExpansionButton(
              context,
              label: 'Terms of Use - Privacy Policy',
              children: [
                _buildButton(
                  context,
                  label: 'Read the Terms of Use',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TermsPage()),
                    );
                  },
                ),
                _buildButton(
                  context,
                  label: 'Read the Privacy Policy',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PrivacyPage()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context,
      {required String label, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildExpansionButton(BuildContext context,
      {required String label, required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTile(
        title: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(label),
        ),
        children: children,
      ),
    );
  }
}

// Página de FAQs
class FAQsPage extends StatelessWidget {
  const FAQsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FAQs')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Frequently Asked Questions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(
                '1. What are the gym hours?\nWe are open 24/7 for premium members. Regular members can access from 6 AM to 10 PM.'),
            SizedBox(height: 10),
            Text(
                '2. Can I freeze my membership?\nYes, you can freeze your membership for up to 3 months by contacting support.'),
          ],
        ),
      ),
    );
  }
}

// Página de Contato
class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact us')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Contact Pulse Gym',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Email: support@pulsegym.com'),
            Text('Phone: +351 912 345 678'),
            Text('Address: Rua de Santa Catarina, 123, Porto - 4400-084'),
          ],
        ),
      ),
    );
  }
}

// Página de Termos de Uso
class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms of Use')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pulse Gym - Terms of Use',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('1. Membership is non-transferable.'),
            Text('2. Payments are due monthly and non-refundable.'),
            Text('3. Gym facilities must be used responsibly.'),
          ],
        ),
      ),
    );
  }
}

// Página de Política de Privacidade
class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pulse Gym - Privacy Policy',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(
                '1. We collect and store personal data for membership management.'),
            Text('2. Your data is never shared with third parties.'),
            Text('3. You can request data deletion at any time.'),
          ],
        ),
      ),
    );
  }
}
