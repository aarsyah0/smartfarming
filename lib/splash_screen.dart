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
    final logoSize = size.width * 0.23;
    final borderRadius = size.width * 0.07;
    final textSizeFrom = size.width * 0.025;
    final textSizePolije = size.width * 0.028;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Container(
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
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: size.height * 0.06,
            child: Column(
              children: [
                Text(
                  'from',
                  style: TextStyle(
                    fontSize: textSizeFrom,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: size.height * 0.006),
                Text(
                  'Politeknik Negeri Jember',
                  style: TextStyle(
                    fontSize: textSizePolije,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
