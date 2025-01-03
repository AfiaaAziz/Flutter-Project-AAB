import 'package:flutter/material.dart';
import 'login_signup_page.dart'; // Import the login/signup page

class CountrySelectionPage extends StatefulWidget {
  const CountrySelectionPage({super.key});

  @override
  CountrySelectionPageState createState() => CountrySelectionPageState();
}

class CountrySelectionPageState extends State<CountrySelectionPage> {
  final List<String> countries = [
    'Pakistan',
    'United States',
    'Canada',
    'United Kingdom',
    'Australia',
    'Global',
  ];

  String? selectedCountry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                "https://i.pinimg.com/736x/6e/f8/02/6ef802410c3bf66875f88a078062c2f1.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo in Circular Shape
                ClipOval(
                  child: Image.asset(
                    'assets/images/aab.jpg', // Path to your logo image
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 100), // Space after the logo

                // Main Container with Shadow Effect
                Container(
                  width: 350,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9), // Slight transparency
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header text
                      const Text(
                        'Select Your Country',
                        style: TextStyle(
                          fontSize: 28, // Bigger text for prominence
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Dropdown Button with more modern style
                      DropdownButton<String>(
                        value: selectedCountry,
                        hint: Text(
                          "Choose a country",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16,
                          ),
                        ),
                        isExpanded: true,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCountry = newValue;
                          });
                        },
                        items: countries.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      // Modern Button with gradient background and rounded corners
                      ElevatedButton(
                        onPressed: () {
                          if (selectedCountry != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginSignupPage()),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          shadowColor: Colors.black.withOpacity(0.2),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
