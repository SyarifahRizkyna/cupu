import 'package:flutter/material.dart';

class StatusLayout extends StatelessWidget {
  final String? message; // Add nullability to the message

  const StatusLayout({super.key, 
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Fixed syntax here
      home: Scaffold(
        body: Center(
          child: Text(message ?? "No message provided"), // Display the message or a default if null
        ),
      ),
    );
  }
}
