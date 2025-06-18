import 'dart:ui';

import 'package:flutter/material.dart';
import 'history_page.dart';

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
  int _selectedIndex = 0;
  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  List<HistoryEntry> history = [];

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

  void _onNavTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _addHistory() {
    history.add(HistoryEntry(
      time: DateTime.now(),
      temperature: temperature,
      humidity: humidity,
      fanOn: fanOn,
      pumpOn: pumpOn,
    ));
  }

  Widget _buildDashboard(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    // Palet warna
    const greenPrimary = Color(0xFF1CB56B);
    const greenGradientStart = Color(0xFF43EA7A);
    const greenBg = Color(0xFFF6FFF9);
    const blueTemp = Color(0xFF4FC3F7);
    const blueHumidity = Color(0xFF0288D1);
    final time = TimeOfDay.now().format(context);

    // Header
    final headerHeight = height * 0.17;
    final logoSize = width * 0.10;
    final welcomeFont = width * 0.045;
    final timeFont = width * 0.032;

    // Grid
    final gridPadding = width * 0.04;
    final gridSpacing = width * 0.03;
    final cardRadius = 18.0;
    final cardElevation = 0.0;
    final cardFont = width * 0.045;
    final cardIcon = width * 0.11;
    final buttonFont = width * 0.038;
    final buttonPad = width * 0.03;

    return Scaffold(
      backgroundColor: greenBg,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Dashboard utama
          Column(
            children: [
              // Header
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: headerHeight,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/greenhouse.jpg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.black.withOpacity(0.5),
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.2),
                          ],
                          stops: [0.0, 0.5, 1.0],
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(32),
                          bottomRight: Radius.circular(32),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 24, top: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    'Welcome',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: welcomeFont * 1.1,
                                      letterSpacing: 1.2,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(1, 1),
                                          blurRadius: 8,
                                          color: Colors.black.withOpacity(0.3),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12),
                                Container(
                                  width: logoSize,
                                  height: logoSize,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 12,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 5,
                                        sigmaY: 5,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(logoSize * 0.13),
                                        child: Image.asset('assets/logo.png'),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          SizedBox(width: logoSize * 0.5),
                        ],
                      ),
                    ),
                  ),
                  // Jam di luar header card, rata kanan
                  Positioned(
                    right: 24,
                    top: headerHeight - (timeFont * 2.5),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            time,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: timeFont,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: gridPadding),
              // Grid 2x2
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: gridPadding),
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: gridSpacing,
                    crossAxisSpacing: gridSpacing,
                    childAspectRatio: 1,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      // Temperature
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final cardW = constraints.maxWidth;
                          final cardH = constraints.maxHeight;
                          final iconSize = cardW * 0.22;
                          final labelFont = cardW * 0.10;
                          final valueFont = cardW * 0.12;
                          final pad = cardH * 0.05;
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(cardRadius),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(cardRadius),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                child: Padding(
                                  padding: EdgeInsets.all(pad),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(iconSize * 0.18),
                                        decoration: BoxDecoration(
                                          color: blueTemp.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          Icons.thermostat_rounded,
                                          color: blueTemp,
                                          size: iconSize,
                                        ),
                                      ),
                                      SizedBox(height: pad * 0.7),
                                      Text(
                                        'Temperature',
                                        style: TextStyle(
                                          fontSize: labelFont,
                                          fontWeight: FontWeight.w600,
                                          color: blueTemp,
                                        ),
                                      ),
                                      SizedBox(height: pad * 0.3),
                                      Text(
                                        '${temperature.toStringAsFixed(1)} °C',
                                        style: TextStyle(
                                          fontSize: valueFont,
                                          fontWeight: FontWeight.bold,
                                          color: blueTemp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      // Humidity
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final cardW = constraints.maxWidth;
                          final cardH = constraints.maxHeight;
                          final iconSize = cardW * 0.22;
                          final labelFont = cardW * 0.10;
                          final valueFont = cardW * 0.12;
                          final pad = cardH * 0.05;
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(cardRadius),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(cardRadius),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                child: Padding(
                                  padding: EdgeInsets.all(pad),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(iconSize * 0.18),
                                        decoration: BoxDecoration(
                                          color: blueHumidity.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          Icons.water_drop_rounded,
                                          color: blueHumidity,
                                          size: iconSize,
                                        ),
                                      ),
                                      SizedBox(height: pad * 0.7),
                                      Text(
                                        'Humidity',
                                        style: TextStyle(
                                          fontSize: labelFont,
                                          fontWeight: FontWeight.w600,
                                          color: blueHumidity,
                                        ),
                                      ),
                                      SizedBox(height: pad * 0.3),
                                      Text(
                                        '${humidity.toStringAsFixed(1)} %',
                                        style: TextStyle(
                                          fontSize: valueFont,
                                          fontWeight: FontWeight.bold,
                                          color: blueHumidity,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      // Kipas
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final cardW = constraints.maxWidth;
                          final cardH = constraints.maxHeight;
                          final iconSize = cardW * 0.22;
                          final labelFont = cardW * 0.10;
                          final valueFont = cardW * 0.12;
                          final pad = cardH * 0.05;
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(cardRadius),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(cardRadius),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                child: Padding(
                                  padding: EdgeInsets.all(pad),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(iconSize * 0.18),
                                        decoration: BoxDecoration(
                                          color: greenPrimary.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          Icons.ac_unit_rounded,
                                          color: greenPrimary,
                                          size: iconSize,
                                        ),
                                      ),
                                      SizedBox(height: pad * 0.7),
                                      Text(
                                        'Kipas',
                                        style: TextStyle(
                                          fontSize: labelFont,
                                          fontWeight: FontWeight.w600,
                                          color: greenPrimary,
                                        ),
                                      ),
                                      SizedBox(height: pad * 0.5),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            fanOn = !fanOn;
                                            _addHistory();
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: pad * 1.2,
                                            vertical: pad * 0.7,
                                          ),
                                          decoration: BoxDecoration(
                                            color: fanOn ? greenPrimary : Colors.grey[200],
                                            borderRadius: BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: (fanOn ? greenPrimary : Colors.grey[300]!).withOpacity(0.3),
                                                blurRadius: 6,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            fanOn ? 'ON' : 'OFF',
                                            style: TextStyle(
                                              color: fanOn ? Colors.white : Colors.grey[600],
                                              fontSize: labelFont * 0.8,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      // Pompa
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final cardW = constraints.maxWidth;
                          final cardH = constraints.maxHeight;
                          final iconSize = cardW * 0.22;
                          final labelFont = cardW * 0.10;
                          final valueFont = cardW * 0.12;
                          final pad = cardH * 0.05;
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(cardRadius),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(cardRadius),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                child: Padding(
                                  padding: EdgeInsets.all(pad),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(iconSize * 0.18),
                                        decoration: BoxDecoration(
                                          color: greenPrimary.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          Icons.water_rounded,
                                          color: greenPrimary,
                                          size: iconSize,
                                        ),
                                      ),
                                      SizedBox(height: pad * 0.7),
                                      Text(
                                        'Pompa',
                                        style: TextStyle(
                                          fontSize: labelFont,
                                          fontWeight: FontWeight.w600,
                                          color: greenPrimary,
                                        ),
                                      ),
                                      SizedBox(height: pad * 0.5),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            pumpOn = !pumpOn;
                                            _addHistory();
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: pad * 1.2,
                                            vertical: pad * 0.7,
                                          ),
                                          decoration: BoxDecoration(
                                            color: pumpOn ? greenPrimary : Colors.grey[200],
                                            borderRadius: BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: (pumpOn ? greenPrimary : Colors.grey[300]!).withOpacity(0.3),
                                                blurRadius: 6,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            pumpOn ? 'ON' : 'OFF',
                                            style: TextStyle(
                                              color: pumpOn ? Colors.white : Colors.grey[600],
                                              fontSize: labelFont * 0.8,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // History page
          HistoryPage(history: history),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onNavTapped,
              selectedItemColor: greenPrimary,
              unselectedItemColor: Colors.grey[400],
              selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard_rounded),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history_rounded),
                  label: 'History',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildDashboard(context);
  }
}
