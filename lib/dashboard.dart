import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  double temperature = 0.0;
  double humidity = 0.0;
  bool fanOn = false;
  bool pumpOn = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardWidth = size.width * 0.90;
    final cardHeight = size.height * 0.15;
    final iconSize = size.width * 0.13;
    final fontSize = size.width * 0.052;
    final time = TimeOfDay.now().format(context);
    // Palet warna
    const greenPrimary = Color(0xFF1CB56B);
    const greenGradientStart = Color(0xFF43EA7A);
    const greenBg = Color(0xFFF6FFF9);
    const blueTemp = Color(0xFF4FC3F7);
    const blueHumidity = Color(0xFF0288D1);
    const yellowBadge = Color(0xFFFFF9C4);
    const cardShadow = Color(0x331CB56B);
    const borderRadius = 24.0;

    return Scaffold(
      backgroundColor: greenBg,
      body: Column(
        children: [
          // Modern custom header
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [greenGradientStart, greenPrimary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: cardShadow,
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.025),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.eco,
                        color: greenPrimary,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      'Smart Farming',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: size.width * 0.065,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.012),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: yellowBadge.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: greenPrimary,
                        size: 20,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        time,
                        style: const TextStyle(
                          color: greenPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.025),
              ],
            ),
          ),
          const Spacer(flex: 2),
          FadeTransition(
            opacity: _fadeAnim,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Card suhu
                Container(
                  width: cardWidth,
                  height: cardHeight,
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(borderRadius),
                    boxShadow: [
                      BoxShadow(
                        color: cardShadow,
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: blueTemp.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              padding: const EdgeInsets.all(14),
                              child: Icon(
                                Icons.thermostat,
                                color: blueTemp,
                                size: iconSize,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: blueTemp,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  '°C',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Temperature',
                              style: TextStyle(
                                color: blueTemp,
                                fontSize: fontSize * 0.95,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${temperature.toStringAsFixed(1)}',
                              style: TextStyle(
                                color: blueTemp,
                                fontSize: fontSize * 1.35,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 18),
                    ],
                  ),
                ),
                // Card kelembapan
                Container(
                  width: cardWidth,
                  height: cardHeight,
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(borderRadius),
                    boxShadow: [
                      BoxShadow(
                        color: cardShadow,
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: blueHumidity.withOpacity(0.13),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              padding: const EdgeInsets.all(14),
                              child: Icon(
                                Icons.water_drop,
                                color: blueHumidity,
                                size: iconSize,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: blueHumidity,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  '%',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Humidity',
                              style: TextStyle(
                                color: blueHumidity,
                                fontSize: fontSize * 0.95,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${humidity.toStringAsFixed(1)}',
                              style: TextStyle(
                                color: blueHumidity,
                                fontSize: fontSize * 1.35,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 18),
                    ],
                  ),
                ),
                // Tombol
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          fanOn = !fanOn;
                        });
                      },
                      icon: Icon(
                        Icons.tornado,
                        color: fanOn ? Colors.white : greenPrimary,
                      ),
                      label: Text(
                        fanOn ? 'Kipas ON' : 'Kipas OFF',
                        style: TextStyle(
                          color: fanOn ? Colors.white : greenPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: fanOn ? greenPrimary : Colors.white,
                        side: const BorderSide(color: greenPrimary, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.09,
                          vertical: size.height * 0.018,
                        ),
                      ),
                    ),
                    SizedBox(width: size.width * 0.06),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          pumpOn = !pumpOn;
                        });
                      },
                      icon: Icon(
                        Icons.water,
                        color: pumpOn ? Colors.white : greenPrimary,
                      ),
                      label: Text(
                        pumpOn ? 'Pompa ON' : 'Pompa OFF',
                        style: TextStyle(
                          color: pumpOn ? Colors.white : greenPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: pumpOn ? greenPrimary : Colors.white,
                        side: const BorderSide(color: greenPrimary, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.09,
                          vertical: size.height * 0.018,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}
