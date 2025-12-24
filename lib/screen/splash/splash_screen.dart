import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfffcf5),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Image(
                image: AssetImage('assets/logo.jpg'),
                width: 250,
                height: 250,
              ),
              // SizedBox(height: 10),
              // Text("Lush Car Wash", style: TextStyle(color: Colors.black, fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
