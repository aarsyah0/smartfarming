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
    final width = size.width;
    final height = size.height;
    final cardWidth = width * 0.92;
    final cardHeight = height * 0.15;
    final iconSize = width * 0.13;
    final fontSize = width * 0.052;
    final borderRadius = width * 0.06;
    final buttonFont = width * 0.045;
    final buttonPaddingH = width * 0.09;
    final buttonPaddingV = height * 0.018;
    final time = TimeOfDay.now().format(context);
    // Palet warna
    const greenPrimary = Color(0xFF1CB56B);
    const greenGradientStart = Color(0xFF43EA7A);
    const greenBg = Color(0xFFF6FFF9);
    const blueTemp = Color(0xFF4FC3F7);
    const blueHumidity = Color(0xFF0288D1);
    const yellowBadge = Color(0xFFFFF9C4);
    const cardShadow = Color(0x331CB56B);

    return Scaffold(
      backgroundColor: greenBg,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              // Modern custom header
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [greenGradientStart, greenPrimary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(width * 0.08),
                    bottomRight: Radius.circular(width * 0.08),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: cardShadow,
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: height * 0.025),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: width * 0.12,
                          height: width * 0.12,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(width * 0.035),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.eco,
                            color: greenPrimary,
                            size: width * 0.08,
                          ),
                        ),
                        SizedBox(width: width * 0.04),
                        Text(
                          'Smart Farming',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.065,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.012),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.045,
                        vertical: height * 0.008,
                      ),
                      decoration: BoxDecoration(
                        color: yellowBadge.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(width * 0.04),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time,
                            color: greenPrimary,
                            size: width * 0.055,
                          ),
                          SizedBox(width: width * 0.018),
                          Text(
                            time,
                            style: TextStyle(
                              color: greenPrimary,
                              fontSize: width * 0.045,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.025),
                  ],
                ),
              ),
              SizedBox(height: height * 0.03),
              Expanded(
                child: Center(
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Card suhu
                        Container(
                          width: cardWidth,
                          height: cardHeight,
                          margin: EdgeInsets.only(bottom: height * 0.022),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(borderRadius),
                            boxShadow: [
                              BoxShadow(
                                color: cardShadow,
                                blurRadius: 18,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: width * 0.045),
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: blueTemp.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(width * 0.045),
                                      ),
                                      padding: EdgeInsets.all(width * 0.038),
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
                                        padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.025,
                                          vertical: height * 0.003,
                                        ),
                                        decoration: BoxDecoration(
                                          color: blueTemp,
                                          borderRadius: BorderRadius.circular(width * 0.03),
                                        ),
                                        child: Text(
                                          '°C',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: width * 0.032,
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
                              SizedBox(width: width * 0.045),
                            ],
                          ),
                        ),
                        // Card kelembapan
                        Container(
                          width: cardWidth,
                          height: cardHeight,
                          margin: EdgeInsets.only(bottom: height * 0.022),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(borderRadius),
                            boxShadow: [
                              BoxShadow(
                                color: cardShadow,
                                blurRadius: 18,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: width * 0.045),
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: blueHumidity.withOpacity(0.13),
                                        borderRadius: BorderRadius.circular(width * 0.045),
                                      ),
                                      padding: EdgeInsets.all(width * 0.038),
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
                                        padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.025,
                                          vertical: height * 0.003,
                                        ),
                                        decoration: BoxDecoration(
                                          color: blueHumidity,
                                          borderRadius: BorderRadius.circular(width * 0.03),
                                        ),
                                        child: Text(
                                          '%',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: width * 0.032,
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
                              SizedBox(width: width * 0.045),
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
                                size: width * 0.07,
                              ),
                              label: Text(
                                fanOn ? 'Kipas ON' : 'Kipas OFF',
                                style: TextStyle(
                                  color: fanOn ? Colors.white : greenPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: buttonFont,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: fanOn ? greenPrimary : Colors.white,
                                side: BorderSide(color: greenPrimary, width: width * 0.008),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(width * 0.06),
                                ),
                                elevation: 0,
                                padding: EdgeInsets.symmetric(
                                  horizontal: buttonPaddingH,
                                  vertical: buttonPaddingV,
                                ),
                              ),
                            ),
                            SizedBox(width: width * 0.06),
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  pumpOn = !pumpOn;
                                });
                              },
                              icon: Icon(
                                Icons.water,
                                color: pumpOn ? Colors.white : greenPrimary,
                                size: width * 0.07,
                              ),
                              label: Text(
                                pumpOn ? 'Pompa ON' : 'Pompa OFF',
                                style: TextStyle(
                                  color: pumpOn ? Colors.white : greenPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: buttonFont,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: pumpOn ? greenPrimary : Colors.white,
                                side: BorderSide(color: greenPrimary, width: width * 0.008),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(width * 0.06),
                                ),
                                elevation: 0,
                                padding: EdgeInsets.symmetric(
                                  horizontal: buttonPaddingH,
                                  vertical: buttonPaddingV,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
