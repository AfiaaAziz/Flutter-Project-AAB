import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  ContactPageState createState() => ContactPageState();
}

class ContactPageState extends State<ContactPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  // Focus nodes for better keyboard management
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _messageFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _messageController.dispose();
    _emailFocusNode.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contact Us',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 5,
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.network(
              'https://i.pinimg.com/736x/59/a7/d3/59a7d3f3f5952778c1930e7766af2b8f.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Overlay for content readability
          Container(
            color: Colors.black.withOpacity(0.1),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'We’d love to hear from you!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextLabel('Enter your Email ID'),
                _buildTextField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  labelText: 'Email',
                  hintText: 'example@example.com',
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 30),
                _buildTextLabel('Your Message'),
                _buildTextField(
                  controller: _messageController,
                  focusNode: _messageFocusNode,
                  labelText: 'Message',
                  hintText: 'Type your message here...',
                  icon: Icons.message_outlined,
                  maxLines: 5,
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    onPressed: () {
                      _sendMessage(context);
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Center(
                  child: Text(
                    'Follow Us',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialIcon(
                      FontAwesomeIcons.instagram,
                      Colors.pink,
                      'https://www.instagram.com/?hl=en',
                    ),
                    const SizedBox(width: 20),
                    _buildSocialIcon(
                      FontAwesomeIcons.twitter,
                      Colors.blue,
                      'https://www.twitter.com/yourProfile',
                    ),
                    const SizedBox(width: 20),
                    _buildSocialIcon(
                      FontAwesomeIcons.facebook,
                      Colors.blue.shade900,
                      'https://www.facebook.com/yourProfile',
                    ),
                    const SizedBox(width: 20),
                    _buildSocialIcon(
                      FontAwesomeIcons.linkedin,
                      Colors.blueAccent,
                      'https://www.linkedin.com',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    required String hintText,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode, // Ensure the focus node is assigned
      maxLines: maxLines,
      style: const TextStyle(color: Colors.black),
      cursorColor: Colors.black, // Sets the cursor color to black
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey),
        labelText: labelText,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color, String url) {
    return IconButton(
      icon: FaIcon(icon, color: color, size: 30),
      onPressed: () async {
        final Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          throw 'Could not launch $url';
        }
      },
    );
  }

  void _sendMessage(BuildContext context) {
    if (_emailController.text.isNotEmpty && _messageController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('messages').add({
        'email': _emailController.text,
        'message': _messageController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _emailController.clear();
      _messageController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Message sent! Thank you for reaching out.'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields.'),
        ),
      );
    }
  }
}
