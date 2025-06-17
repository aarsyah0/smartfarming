import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final logoSize = size.width * 0.3;
    final borderRadius = size.width * 0.08;
    final fontSize = size.width * 0.08;
    final progressSize = size.width * 0.1;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: logoSize,
              height: logoSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                color: Colors.green[100],
              ),
              child: Padding(
                padding: EdgeInsets.all(logoSize * 0.13),
                child: Image.asset('assets/logo.png'),
              ),
            ),
            SizedBox(height: size.height * 0.03),
            Text(
              'Smart Farm',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: size.height * 0.04),
            SizedBox(
              width: progressSize,
              height: progressSize,
              child: const CircularProgressIndicator(color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
