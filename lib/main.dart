import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'country_selection_page.dart'; // Import the country selection page
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Supabase.initialize(
    url:  'https://rcijdrxsqwpdmtjfbtye.supabase.co',
    anonKey:
       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJjaWpkcnhzcXdwZG10amZidHllIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQxMDgyODYsImV4cCI6MjA0OTY4NDI4Nn0.RpdzVfhx0XDLBzqfTHlb5cduKb2TY2NSSb06JMR0MK4' ,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home:
          const CountrySelectionPage(), // Initial route is the country selection page
    );
  }
}
