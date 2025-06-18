import 'dart:ui';

import 'package:flutter/material.dart';

import 'firebase_service.dart';
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
  bool isManual = false;
  int _selectedIndex = 0;
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  final FirebaseService _firebaseService = FirebaseService();

  List<Map<String, dynamic>> history = [];

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

    // Listen to sensor data
    _firebaseService.getSensorData().listen((data) {
      if (mounted) {
        setState(() {
          temperature = data['temperature'] ?? 0.0;
          humidity = data['humidity'] ?? 0.0;
        });
      }
    });

    // Listen to fan status from status/kipas
    _firebaseService.getFanStatus().listen((status) {
      if (mounted) {
        setState(() {
          fanOn = status;
        });
        // Sinkronkan ke control/kipas
        _firebaseService.setControlFanFromStatus(status);
      }
    });

    // Listen to pump status from status/pompa
    _firebaseService.getPumpStatus().listen((status) {
      if (mounted) {
        setState(() {
          pumpOn = status;
        });
        // Sinkronkan ke control/pompa
        _firebaseService.setControlPumpFromStatus(status);
      }
    });

    // Listen to manual mode
    _firebaseService.getManualMode().listen((manual) {
      if (mounted) {
        setState(() {
          isManual = manual;
        });
      }
    });

    // Listen to history data
    _firebaseService.getHistory().listen((data) {
      if (mounted) {
        setState(() {
          history = data;
        });
      }
    });
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
    final historyData = {
      'temperature': temperature,
      'humidity': humidity,
      'fanOn': fanOn,
      'pumpOn': pumpOn,
    };
    _firebaseService.addHistory(historyData);
  }

  // Update the fan toggle handler
  void _toggleFan() {
    final newStatus = !fanOn;
    setState(() {
      fanOn = newStatus;
    });
    // Update status/kipas to match the control state
    _firebaseService.updateFanStatus(newStatus);
    _addHistory();
  }

  // Update the pump toggle handler
  void _togglePump() {
    final newStatus = !pumpOn;
    setState(() {
      pumpOn = newStatus;
    });
    // Update status/pompa to match the control state
    _firebaseService.updatePumpStatus(newStatus);
    _addHistory();
  }

  Widget _buildControlButton({
    required bool isOn,
    required VoidCallback onTap,
    required String label,
    required IconData icon,
    required Color color,
    required bool enabled,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(5),
        child: Opacity(
          opacity: enabled ? 1.0 : 0.5,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(icon, color: color, size: 28),
                  ),
                  SizedBox(height: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  SizedBox(height: 8),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: isOn ? color : Colors.grey[200],
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: (isOn ? color : Colors.grey[300]!).withOpacity(
                            0.3,
                          ),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      isOn ? 'ON' : 'OFF',
                      style: TextStyle(
                        color: isOn ? Colors.white : Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSensorCard({
    required String label,
    required double value,
    required String unit,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${value.toStringAsFixed(1)} $unit',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
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
    final headerHeight = height * 0.15;
    final logoSize = width * 0.08;
    final welcomeFont = width * 0.04;
    final timeFont = width * 0.03;

    // Grid
    final gridPadding = width * 0.04;
    final gridSpacing = width * 0.03;

    return Scaffold(
      backgroundColor: greenBg,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Dashboard utama
          SafeArea(
            child: Column(
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
                              padding: EdgeInsets.only(left: 20, top: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
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
                                        fontSize: welcomeFont,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    width: logoSize,
                                    height: logoSize,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.15),
                                          blurRadius: 8,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 5,
                                          sigmaY: 5,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                            logoSize * 0.2,
                                          ),
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
                      right: 20,
                      top: headerHeight - (timeFont * 2.5),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              time,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: timeFont,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Tambahkan switch manual mode di sini
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Mode Manual',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Switch(
                        value: isManual,
                        onChanged: (val) {
                          _firebaseService.setManualMode(val);
                        },
                        activeColor: greenPrimary,
                      ),
                    ],
                  ),
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
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        // Temperature
                        _buildSensorCard(
                          label: 'Temperature',
                          value: temperature,
                          unit: '°C',
                          icon: Icons.thermostat_rounded,
                          color: blueTemp,
                        ),
                        // Humidity
                        _buildSensorCard(
                          label: 'Humidity',
                          value: humidity,
                          unit: '%',
                          icon: Icons.water_drop_rounded,
                          color: blueHumidity,
                        ),
                        // Fan Control
                        _buildControlButton(
                          isOn: fanOn,
                          onTap: _toggleFan,
                          label: 'Kipas',
                          icon: Icons.ac_unit_rounded,
                          color: greenPrimary,
                          enabled: isManual,
                        ),
                        // Pump Control
                        _buildControlButton(
                          isOn: pumpOn,
                          onTap: _togglePump,
                          label: 'Pompa',
                          icon: Icons.water_rounded,
                          color: greenPrimary,
                          enabled: isManual,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
